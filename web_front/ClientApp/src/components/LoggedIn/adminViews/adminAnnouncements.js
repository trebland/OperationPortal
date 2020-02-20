import React, { Component } from 'react'
import AnnouncementCard from '../announcementCard'
import { Button } from 'react-bootstrap/'

export class AdminAnnouncements extends Component {
    constructor(props) {
        super(props)
    }

    render() {
        return (
            <div>
                <Button type="submit" variant="outline-dark" className="float-right">
                    Add New Annoucements
                </Button>
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
        textAlign: "center",
        marginLeft: "180px"
    }
}