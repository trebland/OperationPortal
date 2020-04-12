import React, { Component } from 'react';
import { Calendar, momentLocalizer } from 'react-big-calendar'
import moment from 'moment'
import 'react-big-calendar/lib/css/react-big-calendar.css'
import { Button, Form } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import './legend.css'

// https://www.npmjs.com/package/react-big-calendar
// http://intljusticemission.github.io/react-big-calendar/examples/index.html#intro

const localizer = momentLocalizer(moment)

export class UserCalendar extends Component {
    constructor(props) {
        super(props)
        this.state = {
            eventsapi: [{}],
            groups: [{}],
            redirect: false,
            redirectEvents: false,
            redirectJobs: false,
            clicked: {},
            jwt: props.location.state.jwt,
            date: '',
            saturdays: [{}],
            id: null,
            job_date: ''
        }
        this.getInfo()

    }

    getInfo = () => {
        let date = new Date()
        let month = date.getMonth() + 1
        let year = date.getFullYear()
        fetch('/api/calendar?month=' + month + '&year=' + year , {
          // method: 'GET',
          headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': `Bearer ${this.state.jwt}`
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
            console.log(res)
            let gro = res.groups
            let eve = res.events
            let sch = res.scheduledDates

            let s = sch.map((details) => {
                let year = Number.parseInt(details.substring(0, 4))
                // starts at 0 for january 
                let month = Number.parseInt(details.substring(5, 7)) 
                let day = Number.parseInt(details.substring(8, 10))
                let ret = {
                    year: year,
                    month: month,
                    day: day,
                    'title': 'Volunteering',
                    'role': 'none',
                    'allDay': true,
                    desc: 'You are volunteering on this day.',
                    'start': new Date(year, month - 1, day),
                    'end': new Date(year, month - 1, day),
                    group: false,
                    volunteer: true
                }
                return ret
            })
            
            let e = eve.map((details) => {
                let year = Number.parseInt(details.date.substring(0, 4))
                // starts at 0 for january 
                let month = Number.parseInt(details.date.substring(5, 7)) 
                let day = Number.parseInt(details.date.substring(8, 10))
                let ret = {
                    id: details.id,
                    year: year,
                    month: month,
                    day: day,
                    'title': details.name,
                    'allDay': true,
                    desc: details.description,
                    'start': new Date(year, month - 1, day),
                    'end': new Date(year, month - 1, day),
                    group: false,
                    volunteer: false
                }
                return ret
            })

            let g = gro.map((details) => {
                let year = Number.parseInt(details.date.substring(0, 4))
                // starts at 0 for january 
                let month = Number.parseInt(details.date.substring(5, 7)) 
                let day = Number.parseInt(details.date.substring(8, 10))
                                  
                let ret = {
                    id: details.id,
                    year: year,
                    month: month,
                    day: day,
                    'title': details.name,
                    'allDay': true,
                    desc: 'Groupname:' + details.name,
                    'start': new Date(year, month - 1, day),
                    'end': new Date(year, month - 1, day),
                    group: true,
                    volunteer: false

                }
                return ret
            })
            console.log(s)

            if(this.mounted === true){
                this.setState({
                    groups: g,
                    eventsapi: e,
                    saturdays: s
                })
            }
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
                pathname: '/dashboard',
                state: {
                    jwt: this.state.jwt
                }
                
            }}/>
        }
        else if(this.state.redirectEvents){
            return <Redirect to={{
                pathname: '/user-event-details',
                state: {
                    clicked: this.state.clicked,
                    jwt: this.state.jwt
                }
            }}/>
        }
        else if(this.state.redirectJobs){
            return <Redirect to={{
                pathname: '/user-saturday-jobs',
                state: {
                    jwt: this.state.jwt,
                    id: this.state.id,
                    date: this.state.job_date
                }
            }}/>
        }
    }

    
    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    getEventDetails = (ep) => {

        console.log(ep.year)
        this.setState({
            clicked: ep,
            redirectEvents: true
        })
        console.log(this.state.clicked)
    }

    saturdayJobSignup = (ep) => {
        var date = ep.month + '/' + ep.day + '/' + ep.year
        console.log(date)
        try {
            fetch('api/auth/user' , {
                // method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                  }
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('got user')
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('did not get user')
                    return
                }
            })
            .then((data) => {
                let res = JSON.parse(data)
                res = res.profile.id
                console.log(res)
                this.setState({
                    id: res,
                    job_date: date,
                    redirectJobs: true
                })
            })
        }
        catch(e) {
            console.log(e)
        }
        console.log(ep)

    }

    handleDateChange = (e) => {
        this.setState({
            date: e.target.value
        })
        console.log(this.state.date)
    }

    signUpSaturday = () => {
        let a = this.state.date
        let year = a.substring(0, 4)
        let month = a.substring(5, 7)
        let day = a.substring(8, 10)
        let nue = year + '-' + month + '-' + day
        try {
            fetch('api/calendar/signup/single' , {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                },
                body: JSON.stringify(
                    {
                        date: nue
                    }
                )
            }) 
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('sign up successful')
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('sign up failed')
                    return
                }
            })
            .then(() => {
                window.location.reload(false)
            })
        }
        catch(e) {
            console.log(e)
        }
    }

    renderSignUpSat = () => {
        return (
            <div style={styling.add}>
                <h2>Volunteer for a Saturday</h2>
                <hr></hr>
                <p>If you wish to sign up for a job, please click on the day that you volunteered for.</p>
                <Form>
                    <Form.Group>
                        <Form.Label>Date</Form.Label>
                        <Form.Control type="date" onChange={this.handleDateChange}/>
                        <Form.Text>
                            Please sign up for any Saturday to volunteer. 
                        </Form.Text>
                    </Form.Group>
                    <Button variant="link" variant="primary" size="lg" onClick={this.signUpSaturday}>
                        Sign Up
                    </Button>
                </Form>
            </div>
        )
    }

    render () {
        var a = this.state.saturdays.concat(this.state.groups).concat(this.state.eventsapi)
        return(
            <div>
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>
                <div style={styling.cal}>
                    <h1>Volunteer Calendar</h1>
                    <Calendar
                        selectable
                        popup
                        localizer = {localizer}
                        events = {a}
                        startAccessor = "start"
                        endAccessor = "end"
                        onSelectEvent={e => {
                            if(e.group){
                                alert('Attending Group Name: ' + e.title)
                            }
                            else if(e.volunteer) {
                                this.saturdayJobSignup(e)
                            }
                            else {
                                this.getEventDetails(e)
                            }
                            
                        }}
                        eventPropGetter={
                            (event, start, end, isSelected) => {
                                if(event.group) {
                                    let newStyle = {
                                        backgroundColor: "lightgrey",
                                        color: 'white',
                                        borderRadius: "5px",
                                        border: "none"
                                    };
                                    newStyle.backgroundColor = "green"
                                    return {
                                        className: "",
                                        style: newStyle
                                    }
                                }
                                if(event.volunteer) {
                                    let newStyle = {
                                        backgroundColor: "lightgrey",
                                        color: 'white',
                                        borderRadius: "5px",
                                        border: "none"
                                    };
                                    newStyle.backgroundColor = "orange"
                                    return {
                                        className: "",
                                        style: newStyle
                                    }
                                }
                            }
                        }
                    />
                    <div className='my-legend'>
                        <div className='legend-scale'>
                            <ul className='legend-labels'>
                                <li><span style={{background:'green'}}></span>groups</li>
                                <li><span style={{background:'orange'}}></span>volunteer</li>
                                <li><span style={{background:'blue'}}></span>events</li>
                            </ul>
                        </div>
                    </div>
                    <br></br>
                    {this.renderSignUpSat()}
                </div>
                {this.renderRedirect()}
                
                
            </div> 
        )
    }
}

const styling = {
    cal: {
        height: '550px',
        padding: '20px 20px'
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px'
    },
    add: {
        marginBottom: '50px'
    },
    legends: {
        display: 'inline-flex',
        marginRight: '20px',
        marginTop: '10px'
    }
}


