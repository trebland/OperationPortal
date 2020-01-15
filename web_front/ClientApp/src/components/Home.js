import React, { Component } from 'react';
import BigCalendar from 'react-big-calendar'
import moment from 'moment';
import 'react-big-calendar/lib/css/react-big-calendar.css';

// https://www.npmjs.com/package/react-big-calendar
// http://intljusticemission.github.io/react-big-calendar/examples/index.html#intro

const localizer = BigCalendar.momentLocalizer(moment) // or globalizeLocalizer

export class Home extends Component {
  
  static displayName = Home.name;

  render () {
    return (
      <div>
        <BigCalendar 
          localizer={localizer}
          events={myEventsList}
          startAccessor="start"
          endAccessor="end"
        />
      </div>
    );
  }
}
