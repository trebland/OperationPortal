import React, { Component } from 'react';
import { Calendar, momentLocalizer } from 'react-big-calendar'
import moment from 'moment'
import 'react-big-calendar/lib/css/react-big-calendar.css'
import { Button, Form } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

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
            clicked: {},
            jwt: props.location.state.jwt,
            date: '',
            saturdays: [{}]
        }
        this.getInfo()
        this.getSaturdays()
    }

    getInfo = () => {
        let date = new Date()
        let month = date.getMonth() + 1
        let year = date.getFullYear()
        fetch('/api/calendar?month=' + month + '&year=' + year , {
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
            let gro = res.groups
            let eve = res.events
            
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
                    group: false
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
                    group: true

                }
                return ret
            })

            if(this.mounted === true){
                this.setState({
                    groups: g,
                    eventsapi: e
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

    handleDateChange = (e) => {
        this.setState({
            date: e.target.value
        })
        console.log(this.state.date)
    }

    // only get saturdays for current month
    getSaturdays = () => {
        var my_date = new Date()
        var year = my_date.getFullYear()
        var month = my_date.getMonth()

        var saturdays = [];

        for (var i = 0; i <= new Date(year, month, 0).getDate(); i++) {    
            var date = new Date(year, month, i);

            if (date.getDay() == 6) {
                saturdays.push(date);
            } 
        }
        for(var i = 0; i < saturdays.length; i++) {
            var day = saturdays[i].getDate()
            var nue = (month + 1) + '-' + day + '-' + year
            try {
                fetch('/api/calendar/details?date=' + nue , {
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
                    if(this.mounted === true) {
                        this.setState({
                            saturdays: res
                        })
                    }
                    console.log(this.state.saturdays)
                })
                // .then(() => {

                // })
            }
            catch(e){
                console.log(e)
            }
        }
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
        }
        catch(e) {
            console.log(e)
        }
    }

    renderSignUpSat = () => {
        return (
            <div style={styling.add}>
                <h2>Sign Up</h2>
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
        var a = this.state.groups.concat(this.state.eventsapi)
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
                                alert('Group Name: ' + e.title)
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
                            }
                        }
                    />
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
    }
}


