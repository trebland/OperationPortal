import React, { Component } from 'react';
import { Calendar, momentLocalizer } from 'react-big-calendar'
import moment from 'moment'
import events from './events'
import 'react-big-calendar/lib/css/react-big-calendar.css'

// https://www.npmjs.com/package/react-big-calendar
// http://intljusticemission.github.io/react-big-calendar/examples/index.html#intro

const localizer = momentLocalizer(moment)

export class Home extends Component {

  constructor(props) {
    super(props)
    this.state = {
      // username: (this.props.location.state.username == undefined) ? "" : this.props.location.state.username,
      loggedin: false
    }
  }
  
  static displayName = Home.name;

  render () {
    return(
      <div style={{height: "550px"}}>
        <h1>calendar</h1>
        <Calendar
          localizer = {localizer}
          events = {events}
          startAccessor = "start"
          endAccessor = "end"
        />
      </div>
    )
  }
}
