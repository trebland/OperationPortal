import React, { Component } from 'react'
import AnnouncementCard from '../announcementCard'
import { Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

export class AdminAnnouncements extends Component {
    constructor(props) {
        super(props)
        this.state = {
            redirect: false
        }
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    renderRedirect = () => {
        if(this.state.redirect){
            return (
                <Redirect to={{
                    pathname: '/admin-dashboard'
                }}/>
            )
        }
    }

    render() {
        return (
            <div style={styling.outderdiv}>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>

                <Button variant="primary" size="lg" style={styling.butt} className="float-right">
                    Add New Annoucements
                </Button>
                {/* add new announcements does not work  */}
                <h1 style={styling.head}>Weekly Announcements</h1>
                <br/>
                <br/>
                <AnnouncementCard
                    date="01/01/20"
                    header="No hashbrowns on sunday"
                    paragraph="There will be no hashbrowns on this upcoming sunday"
                />
                <AnnouncementCard
                    date="12/31/19"
                    header="Get ready for Saturday"
                    paragraph="Lorem ipsum dolor sit amet, consectetur adipiscing elit, 
                    sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
                    Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi 
                    ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in 
                    voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat 
                    cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                />
                <AnnouncementCard
                    date="12/21/19"
                    header="I am testing all types of strings"
                    paragraph="Lorem ipsum dolor sit amet, consectetur adipiscing elit, 
                    sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." 
                />
                <AnnouncementCard
                    date="11/04/19"
                    header="Lorem Ipsum?"
                    paragraph="Lorem ipsum dolor sit amet, consectetur adipiscing elit, 
                    sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
                    Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi 
                    ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in 
                    voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat 
                    cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                />
                <AnnouncementCard
                    date="03/18/19"
                    header="Lorem Ipsum."
                    paragraph="Lorem ipsum dolor sit amet, consectetur adipiscing elit, 
                    sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
                    Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi 
                    ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in 
                    voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat 
                    cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                />
            </div>
        )
    }
}
const styling = {
    head: {
        textAlign: "center"
    },
    outderdiv: {
        padding: '20px 20px'
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px',
        marginBottom: '15px'
    }
}