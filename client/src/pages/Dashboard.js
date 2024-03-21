import { Flex, FloatButton } from "antd";
import { LogoutOutlined } from '@ant-design/icons';

import { useHistory } from "react-router-dom";

const Dashboard = ({ user, setUserAuthDetails }) => {
  const history = useHistory();
  if (!user) {
    history.replace("/login");
  }
  const userLogout = () => {
    setUserAuthDetails(null);
    history.push("/login");
  }
  return (
    <Flex vertical align="center">
        <FloatButton icon={<LogoutOutlined />} type="primary" style={{ right: 24 }} onClick={userLogout} />
      <h3> Hello {user.email}</h3>
    </Flex>
  );
};
export default Dashboard;
