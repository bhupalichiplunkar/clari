import { Flex, notification } from "antd";
import { useHistory } from "react-router-dom/cjs/react-router-dom.min";

const Report = ({ user }) => {
  const history = useHistory();
  if (!user) {
    history.replace("/login");
  }
  const [api, contextHolder] = notification.useNotification();

  const showError = () => {
    api.error({
      message: "Something went wrong",
      description: "Could not upload CSV",
    });
  };

  // const onUpload = async (values) => {
  //   try {
  //     const user = { ...values };
  //     const resp = await apiInstance.post(
  //       "/sessions",
  //       { user },
  //       { withCredentials: true }
  //     );
  //     if (resp.status === 200 && resp?.data?.user) {
  //       setUserAuthDetails(resp?.data?.user);
  //       history.push("/login");
  //     } else {
  //       showError();
  //     }
  //   } catch (e) {
  //     showError();
  //   }
  // };

  return (
    <Flex vertical justify="center" align="center">
      {contextHolder}
      Report
    </Flex>
  );
};
export default Report;
