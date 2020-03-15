import React, { Component } from 'react';
import { Route } from 'react-router';
import { Layout } from './components/NotLoggedIn/Layout';
import { Home } from './components/NotLoggedIn/Home';
import { LoginBox } from './components/NotLoggedIn/LoginBox';
import { RegisterBox } from './components/NotLoggedIn/RegisterBox';
import { Testing } from './components/testing'
import { HomeLoggedIn } from './components/LoggedIn/HomeLoggedIn'
import { Announcements } from './components/LoggedIn/Announcements'
import { Profile } from './components/LoggedIn/Profile'
import { AdminAnnouncements } from './components/LoggedIn/adminViews/adminAnnouncements'
import { AdminHome } from './components/LoggedIn/adminViews/adminHome'
import { Baldwin } from './components/NotLoggedIn/baldwin'

import './custom.css'

export default class App extends Component {
  static displayName = App.name;

  constructor(props){
    super(props);
    this.state = {
      loggedin: this.props.loggedin
    }
  }

  render () {
    
    return (
      <div className="root-container">
        <Layout loggedin={this.props.loggedin}>
          {/* <Route exact path='/login' component={LoginBox} />
          <Route exact path='/register' component={RegisterBox} />
          <Route exact path='/testing' component={Testing} />
          <Route exact path='/' component={Home} />
          <Route exact path='/dashboard' component={HomeLoggedIn} />
          <Route exact path='/announcements' component={Announcements} />
          <Route exact path='/profile' component={Profile} />
          <Route exact path='/admin-announcements' component={AdminAnnouncements} />
          <Route exact path='/admin-dashboard' component={AdminHome} /> */}
          <Route exact path='/baldwin' component={Baldwin} />
        </Layout>
        {/* <Home/> */}
        <Baldwin />

      </div>
    );
  }
  
}
