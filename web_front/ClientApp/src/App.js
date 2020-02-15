import React, { Component } from 'react';
import { Route } from 'react-router';
import { Layout } from './components/Layout';
import { Home } from './components/Home';
import { LoginBox } from './components/LoginBox';
import { RegisterBox } from './components/RegisterBox';
import { Testing } from './components/testing'

import './custom.css'

export default class App extends Component {
  static displayName = App.name;

  render () {
    return (
      <div className="root-container">
        <Layout>
          <Route exact path='/defaultview' component={Home} />
          <Route exact path='/login' component={LoginBox} />
          <Route exact path='/register' component={RegisterBox} />
          <Route exact path='/testing' component={Testing} />
        </Layout>
      </div>
    );
  }
  
}
