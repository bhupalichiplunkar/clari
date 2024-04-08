import React, { useEffect, useState } from "react";
import moment from "moment";
import { useHistory } from "react-router-dom";
import {
  Button,
  DatePicker,
  Select,
  Space,
  Table,
  Flex,
  message,
  AutoComplete,
  Input,
  Checkbox,
  Tag,
} from "antd";
import apiInstance from "../utils/apiUtil";
import { useAtom } from "jotai/react";
import { dropDownDataAtom } from "../atoms/drop-down-data-atom";
import { dropDownValuesAtom } from "../atoms/drop-down-values-atom";
import { queryDataAtom } from "../atoms/query-data-atom";
import { QUERY_CONSTANT_COLUMNS } from "../constants/table_constants";
import { CloseCircleOutlined } from "@ant-design/icons";

const { Option } = Select;

const Query = ({ user }) => {
  const history = useHistory();
  if (!user) {
    history.replace("/login");
  }

  const [startDate, setStartDate] = useState(moment("2024-03-14"));
  const [endDate, setEndDate] = useState(moment("2024-03-23"));
  const [conditions, setConditions] = useState([]);
  const [metrics, setMetrics] = useState([]);
  const [loading, setLoading] = useState(false);
  const [dropDownData, setDropDownDataAtom] = useAtom(dropDownDataAtom);
  const [dropDownValues, setDropDownValues] = useAtom(dropDownValuesAtom);
  const [queryData, setQueryData] = useAtom(queryDataAtom);
  const [showROI, setShowROI] = useState(false);
  let columns = [];

  const disabledDate = (current) => {
    return (
      current &&
      (current < moment("2024-01-15") || current > moment("2024-03-31"))
    );
  };

  const handleAddCondition = () => {
    setConditions([
      ...conditions,
      { table: "", column: "", value: "", operator: "=", multiple: false },
    ]);
  };

  const handleConditionChange = (index, key, value, replace = false) => {
    const newConditions = [...conditions];
    if (!replace) {
      if (key === "value" && !!newConditions[index].multiple) {
        newConditions[index][key].push(value);
      } else {
        newConditions[index][key] = value;
      }
    } else {
      newConditions[index][key] = value;
    }

    if (key === "multiple") {
      if (!!value) {
        newConditions[index].value = [];
        newConditions[index].operator = "IN";
      } else {
        newConditions[index].value = "";
        newConditions[index].operator = "=";
      }
    }
    console.log("conditions final", newConditions);
    setConditions(newConditions);
  };

  const handleRemoveCondition = (index) => {
    const newConditions = [...conditions];
    newConditions.splice(index, 1);
    setConditions(newConditions);
  };

  const handleQuery = async (page = 0) => {
    setLoading(true);
    try {
      const response = await apiInstance.post(
        `query/get-data${page > 0 ? `?page=${page}` : ""}`,
        {
          start_date: startDate.format("YYYY-MM-DD"),
          end_date: endDate.format("YYYY-MM-DD"),
          conditions,
          column_values: metrics,
        },
        {
          withCredentials: true,
        }
      );
      const columns = metrics.map((metric) => ({
        title: capitalizeFirstLetter(metric?.replace?.(/_/g, " ")),
        dataIndex: metric,
        key: metric,
        width: 50,
      }));
      response.data.columns = [...QUERY_CONSTANT_COLUMNS, ...columns];
      setQueryData(response?.data);
    } catch (error) {
      message("Error getting data");
    } finally {
      setLoading(false);
    }
  };

  const getDropDownData = async () => {
    try {
      const resp = await apiInstance.get(
        "query/drop-down-data",
        { user },
        { withCredentials: true }
      );
      if (resp.status === 200 && resp?.data?.column_names) {
        setDropDownDataAtom(resp.data.column_names);
      } else {
        message.error("no data");
      }
    } catch (e) {
      message.error("Something went terribly wrong!!!");
    }
  };

  function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
  }

  const renderEntityOptions = (option) => {
    return (
      <Option key={option} value={option}>
        {capitalizeFirstLetter(option)}
      </Option>
    );
  };

  const renderColumnOptions = (option) => {
    return (
      <Option key={option?.key} value={option.key}>
        {option?.value || option.key}
      </Option>
    );
  };

  const getMatchingValues =
    (channel, dimension_name) => async (partial_value) => {
      if (partial_value.length < 3) {
        setDropDownValues([]);
        return;
      }
      try {
        const resp = await apiInstance.post(
          "query/autocomplete",
          { channel, dimension_name, partial_value },
          { withCredentials: true }
        );
        if (resp.status === 200 && resp?.data?.column_values) {
          setDropDownValues(resp.data.column_values);
        } else {
          message.error("no data");
        }
      } catch (e) {
        message.error("Something went terribly wrong!!!");
      }
    };

  const pagination = {
    current: queryData?.page?.page || 0,
    total: queryData?.page?.count || 0,
    onChange: (page) => handleQuery(page),
  };

  const clearSelectedValue = (tag, i) => {
    const value = conditions?.[i]?.value?.filter?.((x) => x !== tag);
    if (value) {
      handleConditionChange(i, "value", value, true);
    }
  };

  const renderInputComponent = (index) => {
    const condition = conditions[index];
    const column =
      dropDownData?.[condition.table]?.find(
        (x) => x.key === condition.column
      ) || {};
    const { value, type = null } = column;

    switch (type) {
      case "string":
        return (
          <Space>
            <Checkbox
              defaultValue={!!condition?.multiple}
              onChange={(e) =>
                handleConditionChange(index, "multiple", e?.target?.checked)
              }
            >
              multiple
            </Checkbox>
            <Flex align="center">
              <AutoComplete
                options={dropDownValues}
                onSelect={(data) => handleConditionChange(index, "value", data)}
                onSearch={getMatchingValues(condition.table, condition.column)}
                disabled={!condition?.table || !condition?.column}
                placeholder={`Enter ${value}`}
                style={{ width: 150, marginRight: "4px" }}
                allowClear
              />
              {condition?.multiple &&
                condition?.value?.map?.((val) => (
                  <Tag
                    key={val}
                    closeIcon={<CloseCircleOutlined />}
                    onClose={() => clearSelectedValue(val, index)}
                  >
                    {val}
                  </Tag>
                ))}
            </Flex>
          </Space>
        );
      case "integer":
      case "float":
        return (
          <Space>
            <Select
              defaultValue="="
              style={{ width: 60 }}
              onChange={(value) =>
                handleConditionChange(index, "operator", value)
              }
            >
              {["=", ">", "<", ">=", "<="].map((op) => (
                <Option key={op} value={op}>
                  {op}
                </Option>
              ))}
            </Select>
            <Input
              onChange={(e) =>
                handleConditionChange(index, "value", e.target.value)
              }
              placeholder={`Enter ${value}`}
              style={{ width: 75 }}
            />
          </Space>
        );
      case "datetime":
        return (
          <DatePicker
            onChange={(date) => handleConditionChange(index, "value", date)}
            placeholder={`Select ${value}`}
            style={{ width: 100 }}
            defaultValue={startDate}
          />
        );
      default:
        return null;
    }
  };

  useEffect(() => {
    getDropDownData();
  }, []);

  if (queryData?.data?.length) {
    if (showROI && metrics.includes("spend") && metrics.includes("revenue")) {
      columns = [
        ...queryData.columns,
        {
          title: "ROI",
          dataIndex: "roi",
          key: "roi",
          width: 65,
          fixed: "right",
          render: (text, record, index) => {
            return (
              record.revenue > 0 &&
              record.spend > 0 && (
                <div key={index}>
                  {(record.revenue / record.spend).toFixed(2)}
                </div>
              )
            );
          },
        },
      ];
    } else {
      columns = queryData?.columns;
    }
  }

  return (
    <Flex vertical align="center">
      <Flex
        vertical
        justify="center"
        align="center"
        style={{ marginBottom: 16, width: "100%" }}
      >
        <Space style={{ margin: 16 }}>
          <DatePicker
            onChange={(date) => setStartDate(date)}
            disabledDate={disabledDate}
            placeholder="Start Date"
            defaultValue={startDate}
          />
          <DatePicker
            onChange={(date) => setEndDate(date)}
            disabledDate={disabledDate}
            placeholder="End Date"
            defaultValue={endDate}
          />
        </Space>

        {conditions.map((condition, index) => (
          <Space key={index} style={{ margin: 4 }}>
            <Select
              style={{ width: 120 }}
              onChange={(value) => handleConditionChange(index, "table", value)}
              placeholder="Entity"
              disabled={!dropDownData || Object.keys(dropDownData).length === 0}
            >
              {dropDownData &&
                Object.keys(dropDownData).map(renderEntityOptions)}
            </Select>
            <Select
              style={{ width: 120 }}
              onChange={(value) =>
                handleConditionChange(index, "column", value)
              }
              disabled={!condition?.table}
              placeholder="Attribute"
            >
              {condition?.table &&
                dropDownData?.[condition.table]?.map(renderColumnOptions)}
            </Select>
            {condition?.column && renderInputComponent(index)}
            <Button onClick={() => handleRemoveCondition(index)}>-</Button>
          </Space>
        ))}
        <Space style={{ marginTop: 4 }}>
          <Button onClick={handleAddCondition}>Add Condition</Button>
        </Space>
        <div style={{ margin: 16, width: 200 }}>
          <Select
            mode="multiple"
            style={{ width: "100%" }}
            onChange={(value) => setMetrics(value)}
            disabled={!dropDownData || Object.keys(dropDownData).length === 0}
            placeholder="Select Metrics"
          >
            {dropDownData?.metrics?.map(renderColumnOptions)}
          </Select>
        </div>
        <div style={{ marginBottom: 16 }}>
          <Button type="primary" onClick={handleQuery} loading={loading}>
            Query
          </Button>
        </div>
      </Flex>
      <Flex justify="flex-end" style={{ marginBottom: "8px" }}>
        <Checkbox
          defaultValue={showROI}
          onChange={(e) => setShowROI(e?.target?.checked)}
          style={{ width: 100 }}
        >
          Show ROI
        </Checkbox>
      </Flex>
      <Flex vertical style={{ width: "90%" }}>
        <Table
          dataSource={queryData?.data || []}
          columns={columns || []}
          loading={loading}
          size={"large"}
          rowKey="id"
          pagination={queryData?.data?.length ? pagination : null}
          bordered
          virtual
        />
      </Flex>
    </Flex>
  );
};
export default Query;
