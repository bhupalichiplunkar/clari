import { Button, Flex, Space, Upload, message } from "antd";
import { useState } from "react";
import { useHistory } from "react-router-dom";
import { UploadOutlined } from "@ant-design/icons";
import { formInstance } from "../utils/apiUtil";

const UploadCSV = ({ user }) => {
  const history = useHistory();

  if (!user) {
    history.replace("/login");
  }

  const [fileList, setFileList] = useState([]);

  const handleFileChange = ({ fileList }) => {
    setFileList(fileList);
  };

  const handleUpload = async () => {
    const formData = new FormData();

    fileList.forEach((file) => {
      formData.append("file", file.originFileObj);
    });

    try {
      const resp = await formInstance.post("/upload-csv", formData, {
        withCredentials: true,
      });

      if (resp.status === 200) {
        message.success(resp?.data?.message);
      } else {
        message.error("Upload failed :( ");
      }
    } catch (error) {
      console.error("Error:", error);
      message.error("Upload failed");
    } finally {
    }
  };

  const clearFiles = () => {
    setFileList([]);
  };

  const goToHome = () => {
    history.push("/");
  };

  return (
    <Flex vertical justify="center" align="center">
      <Flex justify="center" align="top" style={{ marginBottom: 32 }}>
        <Upload
          fileList={fileList}
          onChange={handleFileChange}
          beforeUpload={() => false} // Prevent default upload behavior
        >
          <Button icon={<UploadOutlined />}>Select File</Button>
        </Upload>
        <Button
          type="primary"
          onClick={handleUpload}
          disabled={fileList.length === 0}
          style={{ marginLeft: 32 }}
        >
          Upload
        </Button>
      </Flex>
      <Space style={{ marginTop: 32 }}>
        <Button onClick={clearFiles} disabled={fileList.length === 0}>
          Clear
        </Button>
        <Button onClick={goToHome}>Home</Button>
      </Space>
    </Flex>
  );
};
export default UploadCSV;
