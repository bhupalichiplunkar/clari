import React from "react";
import { Button, Flex, Form, Input, notification } from "antd";
import apiInstance from "../utils/apiUtil";
import { useHistory } from "react-router-dom";

const formItemLayout = {
  labelCol: {
    xs: {
      span: 24,
    },
    sm: {
      span: 10,
    },
  },
  wrapperCol: {
    xs: {
      span: 24,
    },
    sm: {
      span: 16,
    },
  },
};
const tailFormItemLayout = {
  wrapperCol: {
    xs: {
      span: 24,
      offset: 10,
    },
    sm: {
      span: 16,
      offset: 8,
    },
  },
};
const Registration = ({user}) => {
  const history = useHistory();
  if(user) {
    history.replace('/')
  }

  const [form] = Form.useForm();
  const [api, contextHolder] = notification.useNotification();
  

  const onFinish = async (values) => {
    const user = { ...values };
    try {
      const resp = await apiInstance.post(
        "/registrations",
        { user },
        { withCredentials: true }
      );
      console.log(resp);
      if (resp.status === 200) {
        api.success({
          message: "You have been registered succeefully",
          description:
            "Please go ahead and login using your email and password",
          onClose: () => {
            history.push("/login");
          },
        });
      }
    } catch (e) {
      api.error({
        message: "Something went wrong",
        description: "Please contact admin",
      });
    }
  };

  return (
    <Flex vertical justify="center" align="center">
      {contextHolder}
      <Flex justify="center" align="center">
        <h3>Registeration Form</h3>
      </Flex>
      <Form
        {...formItemLayout}
        form={form}
        name="register"
        onFinish={onFinish}
        style={{
          border: "1px solid green",
          borderRadius: 3,
          padding: 32,
        }}
        scrollToFirstError
      >
        <Form.Item
          name="email"
          label="E-mail"
          rules={[
            {
              type: "email",
              message: "The input is not valid E-mail!",
            },
            {
              required: true,
              message: "Please input your E-mail!",
            },
          ]}
        >
          <Input />
        </Form.Item>

        <Form.Item
          name="password"
          label="Password"
          rules={[
            {
              required: true,
              message: "Please input your password!",
            },
          ]}
          hasFeedback
        >
          <Input.Password />
        </Form.Item>

        <Form.Item
          name="password_confirmation"
          label="Confirm Password"
          dependencies={["password"]}
          hasFeedback
          rules={[
            {
              required: true,
              message: "Please confirm your password!",
            },
            ({ getFieldValue }) => ({
              validator(_, value) {
                if (!value || getFieldValue("password") === value) {
                  return Promise.resolve();
                }
                return Promise.reject(
                  new Error("The new password that you entered do not match!")
                );
              },
            }),
          ]}
        >
          <Input.Password />
        </Form.Item>

        <Form.Item {...tailFormItemLayout}>
          <Button type="primary" htmlType="submit">
            Register
          </Button>
        </Form.Item>
      </Form>
    </Flex>
  );
};
export default Registration;
