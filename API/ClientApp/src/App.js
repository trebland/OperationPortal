import React, { Component } from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom'
import { Welcome } from './structures/welcome'
import { LoginBox } from './structures/welcomeOptions/LoginBox'
import { GeneralCalendar } from './structures/welcomeOptions/GeneralCalendar'
import { RegisterBox } from './structures/welcomeOptions/RegisterBox'
import { UserDashboard } from './structures/userViews/userDashboard'
import { AdminDashboard } from './structures/adminViews/adminDashboard'
import { UserCalendar } from './structures/userViews/userCalendar'
import { UserAnnouncements } from './structures/userViews/userAnnouncements'
import { NotFound } from './structures/notFound'
import { UserProfile } from './structures/userViews/userProfile'
import { AdminAnnouncements } from './structures/adminViews/adminAnnouncements'
import { ViewVolunteers } from './structures/adminViews/viewVolunteers'



export default class App extends Component {
  static displayName = App.name;

  render () {
    return (
      <div>
        <Router>
          <Switch>
            <Route exact path='/login' component={LoginBox} />
            <Route exact path='/' component={Welcome} />
            <Route exact path='/general-calendar' component={GeneralCalendar} />
            <Route exact path='/signup' component={RegisterBox} />
            <Route exact path='/dashboard' component={UserDashboard} />
            <Route exact path='/admin-dashboard' component={AdminDashboard} />
            <Route exact path='/user-calendar' component={UserCalendar} />
            <Route exact path='/user-announcements' component={UserAnnouncements} />
            <Route exact path='/user-profile' component={UserProfile} />
            <Route exact path='/admin-announcements' component={AdminAnnouncements} />
            <Route exact path='/admin-volunteer-list' component={ViewVolunteers} />
            <Route component={NotFound} />
          </Switch>
        </Router>
      
      </div>
      
    );
  }
}
