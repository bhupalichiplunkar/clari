import {
  Button,
  Divider,
  Flex,
  FloatButton,
  notification,
  Radio,
  Space,
  Table,
} from "antd";
import { LogoutOutlined, LeftOutlined } from "@ant-design/icons";
import apiInstance from "../utils/apiUtil";
import { useHistory, useParams, useLocation } from "react-router-dom";
import { useEffect, useState } from "react";
import { useAtom } from "jotai";
import { dashboardDataAtom } from "../atoms/dashboard-data-atom";
import { TABLE_COLUMN } from "../constants/table_constants";

const Dashboard = ({ user, setUserAuthDetails }) => {
  const history = useHistory();

  if (!user) {
    history.replace("/login");
  }

  const userLogout = () => {
    setUserAuthDetails(null);
    history.push("/login");
  };

  const { search } = useLocation();
  const { dataLevel } = useParams();
  const [loading, setLoading] = useState(false);
  const [level, setLevel] = useState(dataLevel || "accounts");
  const [dashboardData, setDashboardData] = useAtom(dashboardDataAtom);
  const [api, contextHolder] = notification.useNotification();

  const getData = async (page = 0) => {
    if (level) {
      setLoading(true);
      try {
        let url = `/${level}`;
        if (search && page > 0) {
          url = `${url}${search}&page=${page}`;
        } else if (search && page <= 0) {
          url = `${url}${search}`;
        } else if (!search && page > 0) {
          url = `${url}?page=${page}`;
        }
        const resp = await apiInstance.get(url, { withCredentials: true });
        if (resp.status === 200 && resp?.data) {
          const res = resp?.data;
          setDashboardData((state) => {
            state.level = level;
            state.page = res?.page || null;
            state.data = res.data || [];
            return state;
          });
          setLoading(false);
        } else {
          showError();
          setLoading(false);
        }
      } catch (e) {
        showError();
        setLoading(false);
      }
    }
  };

  const showError = () => {
    api.error({
      message: "Something went wrong",
      description: `Error fetching ${level}s`,
    });
  };

  const pagination = {
    current: dashboardData?.page?.page || 0,
    total: dashboardData?.page?.count || 0,
    onChange: (page) => getData(page),
  };

  const setDataLevel = async (e) => {
    await setLevel(e.target.value || "account");
  };

  let columns = TABLE_COLUMN[level];

  const openSublevel = (id) => {
    let searchQ = "?";
    let sublevel;
    switch (level) {
      case "accounts":
        sublevel = "campaigns";
        searchQ += `account_id=${id}`;
        break;
      case "campaigns":
        sublevel = "adsets";
        searchQ += `campaign_id=${id}`;
        break;
      case "adsets":
        sublevel = "ads";
        searchQ += `adset_id=${id}`;
        break;
      case "ads":
        return;
      default:
        searchQ = "";
    }
    id && history.push(`/see-all/${sublevel}${searchQ}`);
  };

  useEffect(() => {
    getData(0);
  }, [level]);

  const goBack = () => {
    history.goBack();
  };

  return (
    <Flex vertical align="center">
      <FloatButton
        icon={<LogoutOutlined />}
        type="primary"
        style={{ right: 24 }}
        onClick={userLogout}
      />
      {!dataLevel ? (
        <>
          <h3> Hello {user.email}</h3>
          <Divider />
          <Space style={{ margin: 32 }}>
            <Button
              style={{ margin: 16 }}
              onClick={() => history.push("/upload-csv")}
            >
              Upload CSV
            </Button>
            <Button
              style={{ margin: 16 }}
              onClick={() => history.push("/query")}
            >
              Query Data
            </Button>
          </Space>
          <Radio.Group value={level} onChange={setDataLevel}>
            <Radio.Button value="accounts">Accounts</Radio.Button>
            <Radio.Button value="campaigns">Campaigns</Radio.Button>
            <Radio.Button value="adsets">Adsets</Radio.Button>
            <Radio.Button value="ads">Ads</Radio.Button>
          </Radio.Group>
        </>
      ) : null}
      <Divider />
      {level && dashboardData?.data?.length > 0 ? (
        <Table
          dataSource={dashboardData?.data || []}
          rowKey="id"
          columns={columns}
          loading={loading}
          pagination={pagination}
          title={() =>
            dataLevel ? (
              <Space>
                <div onClick={goBack}>
                  <LeftOutlined />{" "}
                </div>
                <span>
                  <b>{level.toUpperCase()}</b>
                </span>
              </Space>
            ) : null
          }
          size={"large"}
          onRow={(record) => {
            return {
              onClick: () => openSublevel(record.id), // click row
            };
          }}
        />
      ) : (
        <Space>
          <div>No data found!!! T-T </div>
          <div onClick={goBack}>Click to go back</div>
        </Space>
      )}
      {contextHolder}
    </Flex>
  );
};
export default Dashboard;
