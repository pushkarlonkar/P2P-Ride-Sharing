import React, { Component, useState, useEffect } from "react";
import Web3 from "web3";
import RideJson from "./contracts/Ride.json";
// import "./App.css";
import { BrowserRouter as Router,Routes, Route, Link } from "react-router-dom";
import Login from "./components/Login/Login.js";




function App() {

  const [loader, setLoader] = useState(false);
  const [P2P, setP2P] = useState();
  const [curAcc, setCuracc] = useState();
  const [web3, setWeb3] = useState();
  const [citId, setcitId] = useState();
  const [citizen, setCitizen] = useState();


  useEffect(() => {
    loadWeb3();
    loadBlockchainData();
  }, []);

  const loadWeb3 = async () => {
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum);
      await window.ethereum.enable();
    } else if (window.web3) {
      window.web3 = new Web3(window.web3.currentProvider);
    } else {
      window.alert(
        "Non-Ethereum browser detected . You should consider trying metamask!"
      );
    }
    console.log("Inside loadweb3");
  };


  const loadBlockchainData = async () => {
    // get the blockchain data here
    // let us code the smart contract now
    // what to do now let us start with making
    // we have to do the browser location
    setLoader(true);
    const web3 = window.web3;
    setWeb3(web3);
    // console.log("inside loadbc");
    const accounts = await web3.eth.getAccounts();
    // this.state.curAccount= accounts[0];
    setCuracc(accounts[0]);
    const networkId = await web3.eth.net.getId();

    const networkData = RideJson.networks[networkId];
    if (networkData) {
      const P2P = new web3.eth.Contract(
        RideJson.abi,
        networkData.address
      );
      setP2P(P2P);
      // pass this CN
      // and access the methods and variable using CN.methods().methodName().call();
      // console.log(CN);
    } else {
      window.alert("Contract Not Deployed to the net");
    }
    setLoader(false);
    console.log("inside load bc after false");
  };

  if (!window.ethereum) {
    return (
      <div>
        <p>No Ethereum Wallet Found</p>
      </div>
    );
  }
  // loader
  if (loader) {
    return <div>LOADING.....</div>;
  }

  return (
    <div className="App">
      {/* <h1>hello world</h1> */}
      <Router>
        <Routes>
          <Route
            exact
            path={"/"}
            render={(props) => (
              <Login
                cjson={P2P}
                curAccount={curAcc}
                setcitId={setcitId}
                setCitizen={setCitizen}
              />
            )}
          />
        </Routes>
      </Router>
    </div>
  );
}

export default App;
