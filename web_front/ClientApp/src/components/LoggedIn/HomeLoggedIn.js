import React, { Component } from 'react';
import { Calendar, momentLocalizer } from 'react-big-calendar'
import moment from 'moment'
import events from './events'
import 'react-big-calendar/lib/css/react-big-calendar.css'
import { Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import '../styles.css'

// https://www.npmjs.com/package/react-big-calendar
// http://intljusticemission.github.io/react-big-calendar/examples/index.html#intro

const localizer = momentLocalizer(moment)

export class HomeLoggedIn extends Component {
    static displayName = HomeLoggedIn.name;

    constructor(props) {
        super(props)
        this.state = {
        // username: (this.props.location.state.username == undefined) ? "" : this.props.location.state.username,
        loggedin: false,
        redirectAnnoucements: false,
        redirectProfile: false
        }
        // console.log(this.state.username)
    }
    setRedirectAnnouncements = () => {
        this.setState({
            redirectAnnoucements: true,
            loggedin: true
        })
    }

    renderRedirectAnnouncements = () => {
        if (this.state.redirectAnnoucements) {
            return <Redirect to={{
                pathname: '/annoucements',
                state: { 
                loggedin: true
                }
            }}/>
        }
    }

    setRedirectProfile = () => {
        this.setState({
            redirectProfile: true,
            loggedin: true
        })
    }

    renderRedirectProfile = () => {
        if(this.state.redirectProfile) {
            return <Redirect to={{
                pathname: '/profile',
                state: {
                    loggedin: true
                }
            }}/>
        }
    }

    render () {
        return(
        <div>
            <div >
                {this.renderRedirectProfile()}
                <button type="button" class="btn-circle btn-xl" onClick={this.setRedirectProfile}>PN</button>
            </div>
            <div style={styles.annoucements}>
                {this.renderRedirectAnnouncements()}
                <Button type="submit" onClick={this.setRedirectAnnouncements} variant="outline-dark" >
                    View Annoucements
                </Button>
            </div>
            <div style={styles.calendar}>
                <h1>calendar logged in</h1>
                <Calendar
                localizer = {localizer}
                events = {events}
                startAccessor = "start"
                endAccessor = "end"
                />
            </div>
            
        </div>
        )
    }
}

const styles = {
    calendar: {
        marginTop: "10px",
        height: "500px"
    },
    annoucements: {
        marginTop: "25px"
    }
    
    
}
