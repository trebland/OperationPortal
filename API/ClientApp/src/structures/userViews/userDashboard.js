import React, { Component } from 'react'
import { Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

export class UserDashboard extends Component {
    
    constructor(props) {
        super(props)
        this.state = {
            jwt: props.location.state.jwt,
            loggedin: props.location.state.loggedin,
            redirectAnnouncements: false,
            redirectProfile: false,
            redirectCal: false,
            redirectLogout: false,
            role: props.location.state.role,
            redirectQR: false
        }
        
    }
    
    renderRedirect = () => {
        if(this.state.redirectAnnouncements){
            return <Redirect to={{
                pathname: '/user-announcements',
                state: { 
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin,
                    role: this.state.role
                }
            }}/>
        }
        else if(this.state.redirectProfile){
            return <Redirect to={{
                pathname: '/user-profile',
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin,
                    role: this.state.role
                }
            }}/>
        }
        else if(this.state.redirectCal){
            return <Redirect to={{
                pathname: '/user-calendar',
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin,
                    role: this.state.role
                }
            }}/>
        }
        else if(this.state.redirectQR){
            return <Redirect to={{
                pathname: '/user-qr-list',
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin,
                    role: this.state.role
                }
            }}/>
        }
        else if(this.state.redirectLogout){
            return <Redirect to={{
                pathname: '/'
            }}/>
        }
        
        
    }

    setRedirectAnnouncements = () => {
        this.setState({
            redirectAnnouncements: true
        })
    }

    setRedirectProfile = () => {
        this.setState({
            redirectProfile: true
        })
    }

    setRedirectCal = () => {
        this.setState({
            redirectCal: true
        })
    }

    setRedirectLogout = () => {
        this.setState({
            redirectLogout: true
        })
    }

    setRedirectQR = () => {
        this.setState({
            redirectQR: true
        })
    }

    busDriverButton = () => {
        if(this.state.role === 'BusDriver') {
            return (
                <center>
                    <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirectProfile}>
                        Edit Profile
                    </Button>

                    <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirectAnnouncements}>
                        View Announcements
                    </Button>

                    <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirectCal}>
                        View Calendar
                    </Button>

                    <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirectQR}>
                        Print QR Sheet
                    </Button>
                </center>
            )
        }
    }

    volunteerButton = () => {
        return (
            <center>
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirectProfile}>
                        Edit Profile
                </Button>

                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirectAnnouncements}>
                    View Announcements
                </Button>

                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirectCal}>
                    View Calendar
                </Button>
            </center>
        )
    }

    
  

    render () {
        var ro 
        var ret = ''
        console.log(this.state.role)
        if(this.state.role != undefined) {
            ro = this.state.role.split(/(?=[A-Z])/)
            if(ro.length === 1) {
                ret = ro[0]
            }
            else {
                ret = ro[0] + ' ' + ro[1]
            }
        }
        console.log(ret)
        
        return(
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.logout} onClick={this.setRedirectLogout}>
                        Logout
                </Button>
                <center>
                    <div style={styling.header}>
                        <h1>Welcome to Orlando Children's Church - {ret} Dashboard</h1>
                    </div>
                </center>
                {this.state.role === 'BusDriver' ? this.busDriverButton() : this.volunteerButton()}
                {/* <center>
                    <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirectProfile}>
                        Edit Profile
                    </Button>

                    <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirectAnnouncements}>
                        View Announcements
                    </Button>

                    <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirectCal}>
                        View Calendar
                    </Button>

                    {this.busDriverButton()}
                </center>   */}
            </div>
        )
    }
}

const styling = {
    header: {
        textAlign: 'center',
        justifyContent: 'center',
        marginTop: '50px'
    },
    butt: {
        marginRight: '25px',
        marginLeft: '25px',
        marginTop: '75px',
        width: '200px',
        height: '200px'
    },
    logout: {
        marginTop: '15px',
        marginLeft: '15px'
    }
}




