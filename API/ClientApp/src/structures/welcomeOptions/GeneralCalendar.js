import React, { Component } from 'react';
import { Calendar, momentLocalizer } from 'react-big-calendar'
import moment from 'moment'
import events from './dummydata/events'
import 'react-big-calendar/lib/css/react-big-calendar.css'
import { Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

// https://www.npmjs.com/package/react-big-calendar
// http://intljusticemission.github.io/react-big-calendar/examples/index.html#intro

const localizer = momentLocalizer(moment)

export class GeneralCalendar extends Component {
    constructor(props) {
        super(props)
        this.state = {
            eventsapi: [{}],
            groups: [{}],
            redirect: false
        }
        this.getInfo()
    }

    getInfo = () => {
        let date = new Date()
        let month = date.getMonth() + 1
        let year = date.getFullYear()
        fetch('http://localhost:5000/api/calendar?month=' + month + '&year=' + year , {
          // method: 'GET',
          headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json'
            }
        })
        .then((res) => {
            console.log(res.status)
            if((res.status === 200 || res.status === 201) && this.mounted === true){
                console.log('Retrieval successful')
                return res.text()
            }
            else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                console.log('Retrieval failed')
                return
            }
        })
        .then((data) => {
            let res = JSON.parse(data)
            let g = res.groups
            let eve = res.events
            
            let e = eve.map((details) => {
                let year = Number.parseInt(details.date.substring(0, 4))
                // starts at 0 for january 
                let month = Number.parseInt(details.date.substring(5, 7)) - 1
                let day = Number.parseInt(details.date.substring(8, 10))
                console.log(month)
                let ret = {
                    'title': details.name,
                    'allDay': true,
                    desc: details.description,
                    'start': new Date(year, month, day),
                    'end': new Date(year, month, day)
                }
                return ret
            })

            if(this.mounted === true){
                this.setState({
                    groups: g,
                    eventsapi: e
                })
            }
            console.log(this.state.eventsapi)
            console.log(events)
        })
        .catch((err) => {
            console.log(err)
        })
    }


  
    componentWillUnmount = () => {
        this.mounted = false
    }
    
    componentDidMount = () => {
        this.mounted = true
    }
    
    renderRedirect = () => {
        if(this.state.redirect){
            return <Redirect to={{
                pathname: '/'
            }}/>
        }
    }
    
    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }


    render () {

        return(
            <div>
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>
                <div style={styling.cal}>
                    <h1>General Calendar</h1>
                    <Calendar
                        selectable
                        popup
                        localizer = {localizer}
                        events = {this.state.eventsapi}
                        startAccessor = "start"
                        endAccessor = "end"
                        onSelectEvent={event => {
                                alert("Title: " + event.title + "\nDescription: " + event.desc)
                            }
                        }
                    />
                </div>
                {this.renderRedirect()}
                
                
            </div> 
        )
    }
}

const styling = {
    cal: {
        height: '600px',
        padding: '20px 20px'
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px'
    }
}


