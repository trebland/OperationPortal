import React, { Component } from 'react';
import { Route } from 'react-router';
import { Welcome } from './structures/welcome'
import { LoginBox } from './structures/welcomeOptions/LoginBox'
import { GeneralCalendar } from './structures/welcomeOptions/GeneralCalendar'
import { RegisterBox } from './structures/welcomeOptions/RegisterBox'
import { UserDashboard } from './structures/userViews/userDashboard'
import { AdminDashboard } from './structures/adminViews/adminDashboard'


export default class App extends Component {
  static displayName = App.name;

  render () {
    return (
      <div>
        <Route exact path='/login' component={LoginBox} />
        <Route exact path='/' component={Welcome} />
        <Route exact path='/general-calendar' component={GeneralCalendar} />
        <Route exact path='/signup' component={RegisterBox} />
        <Route exact path='/dashboard' component={UserDashboard} />
        <Route exact path='/admin-dashboard' component={AdminDashboard} />
      </div>
      
    );
  }
}
