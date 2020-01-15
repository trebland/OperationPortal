import React, { Component } from 'react';
import reactDOM from "react-dom";
import { Route } from 'react-router';
import { Layout } from './components/Layout';
import { Home } from './components/Home';
import { LoginBox } from './pages/LoginBox';
import { RegisterBox } from './pages/RegisterBox';

import './custom.css'

export default class App extends Component {
  static displayName = App.name;

  render () {
    return (
      <div className="root-container">
        <Layout>
          <Route exact path='/' component={Home} />
          <Route exact path='/login' component={LoginBox} />
          <Route exact path='/register' component={RegisterBox} />
        </Layout>
      </div>
    );
  }
  
}
