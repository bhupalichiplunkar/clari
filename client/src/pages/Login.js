import React from "react";
import { LockOutlined, UserOutlined } from "@ant-design/icons";
import { Button, Checkbox, Flex, Form, Input, notification } from "antd";
import { useHistory } from "react-router-dom";
import apiInstance from "../utils/apiUtil";

const Login = ({ user, setUserAuthDetails }) => {
  const history = useHistory();
  if (user) {
    history.replace("/");
  }
  const [api, contextHolder] = notification.useNotification();

  const showError = () => {
    api.error({
      message: "Something went wrong",
      description:
        "Could not log you in. Recheck email and password. If issue persists, please contact admin",
    });
  };

  const onFinish = async (values) => {
    try {
      const user = { ...values };
      const resp = await apiInstance.post(
        "/sessions",
        { user },
        { withCredentials: true }
      );
      if (resp.status === 200 && resp?.data?.user) {
        setUserAuthDetails(resp?.data?.user);
        history.push("/login");
      } else {
        showError();
      }
    } catch (e) {
      showError();
    }
  };

  return (
    <Flex vertical justify="center" align="center">
      {contextHolder}
      <Flex justify="center" align="center">
        <h3>Login to access</h3>
      </Flex>
      <Form
        name="normal_login"
        className="login-form"
        initialValues={{
          remember: true,
        }}
        onFinish={onFinish}
      >
        <Form.Item
          name="email"
          rules={[
            {
              type: "email",
              message: "The input is not valid E-mail!",
            },
            {
              required: true,
              message: "Please input your Email!",
            },
          ]}
        >
          <Input
            prefix={<UserOutlined className="site-form-item-icon" />}
            placeholder="Email"
          />
        </Form.Item>
        <Form.Item
          name="password"
          rules={[
            {
              required: true,
              message: "Please input your Password!",
            },
          ]}
        >
          <Input
            prefix={<LockOutlined className="site-form-item-icon" />}
            type="password"
            placeholder="Password"
          />
        </Form.Item>
        <Form.Item>
          <Form.Item name="remember" valuePropName="checked" noStyle>
            <Checkbox>Remember me</Checkbox>
          </Form.Item>

          {/* <a className="login-form-forgot" href="">
          Forgot password
        </a> */}
        </Form.Item>

        <Form.Item>
          <Button
            type="primary"
            htmlType="submit"
            className="login-form-button"
          >
            Log in
          </Button>
          Or <a href="/registration">register now!</a>
        </Form.Item>
      </Form>
    </Flex>
  );
};
export default Login;
