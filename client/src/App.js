import { BrowserRouter, Switch, Route } from "react-router-dom";
import { createStore, Provider } from "jotai";
import { ConfigProvider } from "antd";
import Dashboard from "./pages/Dashboard";
import Login from "./pages/Login";
import Registration from "./pages/Registration";
import { useState } from "react";

const store = createStore();

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
    <Provider store={store}>
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
                  key="home"
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
              render={(props) => (
                <Registration {...props} user={appState.user} />
              )}
            />
            <Route
              path="/see-all/:dataLevel"
              exact
              render={(props) => (
                <Dashboard
                  key="see-all"
                  {...props}
                  user={appState.user}
                  setUserAuthDetails={setUserAuthDetails}
                />
              )}
            />
          </Switch>
        </BrowserRouter>
      </ConfigProvider>
    </Provider>
  );
}

export default App;
