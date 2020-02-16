import React, { Component } from 'react';
import { Route } from 'react-router';
import { Layout } from './components/NotLoggedIn/Layout';
import { Home } from './components/NotLoggedIn/Home';
import { LoginBox } from './components/NotLoggedIn/LoginBox';
import { RegisterBox } from './components/NotLoggedIn/RegisterBox';
import { Testing } from './components/testing'
import { HomeLoggedIn } from './components/LoggedIn/HomeLoggedIn'
import { Announcements } from './components/LoggedIn/Announcements'

import './custom.css'

export default class App extends Component {
  static displayName = App.name;

  constructor(props){
    super(props);
    this.state = {
      loggedin: false
    }
  }

  render () {
    return (
      <div className="root-container">
        <Layout>
          <Route exact path='/login' component={LoginBox} />
          <Route exact path='/register' component={RegisterBox} />
          <Route exact path='/testing' component={Testing} />
          <Route exact path='/' component={Home} />
          <Route exact path='/user' component={HomeLoggedIn} />
          <Route exact path='/annoucements' component={Announcements} />
        </Layout>
      </div>
    );
  }
  
}
