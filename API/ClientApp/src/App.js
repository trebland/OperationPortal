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
import { ViewVolunteers } from './structures/adminViews/editVolunteers/viewVolunteers'
import { AdminProfile } from './structures/adminViews/adminProfile'
import { AdminCalendar } from './structures/adminViews/calendarFunctions/adminCalendar'
import { ChildrensCalendar } from './structures/adminViews/childrensCalendar'
import { StaffCalendar } from './structures/adminViews/staffCalendar'
import { PrivacyPolicy } from './structures/privacyPolicy'
import { AdminVolunteerEdit } from './structures/adminViews/editVolunteers/adminVolunteerEdit'
import { AdminGetId } from './structures/adminViews/editVolunteers/adminGetId'
import { UserEventDetails } from './structures/userViews/userEventDetails'
import { AdminEventDetails } from './structures/adminViews/calendarFunctions/adminEventDetails'
import { AdminEditEvent } from './structures/adminViews/calendarFunctions/editEvent'
import { AdminBusList } from './structures/adminViews/adminBus/adminBusList'
import { AdminBusCreate } from './structures/adminViews/adminBus/adminBusCreate'
import { AdminBusEdit } from './structures/adminViews/adminBus/adminBusEdit'
import { AdminTrainingList } from './structures/adminViews/adminTraining/adminTrainingList'
import { AdminTrainingCreate } from './structures/adminViews/adminTraining/adminTrainingCreate'
import { AdminTrainingEdit } from './structures/adminViews/adminTraining/adminTrainingEdit'
import { AdminJobList } from './structures/adminViews/adminJob/adminJobList'
import { AdminJobCreate } from './structures/adminViews/adminJob/adminJobCreate'
import { AdminJobEdit } from './structures/adminViews/adminJob/adminJobEdit'

// http://jquense.github.io/react-big-calendar/examples/index.html#basic

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
            <Route exact path='/admin-profile' component={AdminProfile} />
            <Route exact path='/admin-calendar' component={AdminCalendar} />
            <Route exact path='/child-birthday-calendar' component={ChildrensCalendar} />
            <Route exact path='/staff-birthday-calendar' component={StaffCalendar} />
            <Route exact path='/privacy-policy' component={PrivacyPolicy} />
            <Route exact path='/admin-volunteer-edit' component={AdminVolunteerEdit} />
            <Route exact path='/admin-get-id' component={AdminGetId} />
            <Route exact path='/user-event-details' component={UserEventDetails} />
            <Route exact path='/admin-event-details' component={AdminEventDetails} />
            <Route exact path='/admin-event-edit' component={AdminEditEvent} />
            <Route exact path='/admin-bus-list' component={AdminBusList} />
            <Route exact path='/admin-bus-create' component={AdminBusCreate} />
            <Route path='/admin-bus-edit/:id' component={AdminBusEdit}/>
            <Route exact path='/admin-training-list' component={AdminTrainingList} />
            <Route exact path='/admin-training-create' component={AdminTrainingCreate} />
            <Route path='/admin-training-edit/:id' component={AdminTrainingEdit} />
            <Route exact path='/admin-job-list' component={AdminJobList} />
            <Route exact path='/admin-job-create' component={AdminJobCreate} />
            <Route path='/admin-job-edit/:id' component={AdminJobEdit} />
            
            <Route component={NotFound} />
          </Switch>
        </Router>
      
      </div>
      
    );
  }
}
