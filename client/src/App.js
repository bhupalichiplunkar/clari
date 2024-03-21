import { BrowserRouter, Switch, Route } from "react-router-dom";
import { ConfigProvider } from "antd";
import Dashboard from "./pages/Dashboard";
import Login from "./pages/Login";
import Registration from "./pages/Registration";
import { useState } from "react";

function App() {
  let localUser = null;
  try {
    localUser = localStorage.getItem("user")
      ? JSON.parse(localStorage.getItem("user"))
      : null;
  } catch (d) {
    localUser = null;
  }

  const [appState, setAppstate] = useState({
    user: localUser,
  });

  const setUserAuthDetails = (user) => {
    if (user) {
      localStorage.setItem("user", JSON.stringify(user));
    } else {
      localStorage.removeItem("user");
    }
    setAppstate({ user });
  };

  return (
    <ConfigProvider
      theme={{
        token: {
          // Seed Token
          colorPrimary: "#00b96b",
          borderRadius: 2,

          // Alias Token
          colorBgContainer: "#f6ffed",
        },
      }}
    >
      <BrowserRouter>
        <Switch>
          <Route
            exact
            path="/"
            render={(props) => (
              <Dashboard
                {...props}
                user={appState.user}
                setUserAuthDetails={setUserAuthDetails}
              />
            )}
          />
          <Route
            path="/login"
            render={(props) => (
              <Login
                {...props}
                user={appState.user}
                setUserAuthDetails={setUserAuthDetails}
              />
            )}
          />
          <Route
            path="/registration"
            render={(props) => <Registration {...props} user={appState.user} />}
          />
        </Switch>
      </BrowserRouter>
    </ConfigProvider>
  );
}

export default App;
