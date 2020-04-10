import React, { Component } from 'react'
import { Button, Card } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import './cards.css'

export class ViewVolunteers extends Component {
    constructor(props) {
        super(props)
        this.state = {
            jwt: props.location.state.jwt,
            loggedin: props.location.state.loggedin,
            volunteers: [{}],
            redirect: false,
            edit: false
        }
        console.log(this.state.jwt)
        this.getVolunteers()
    }

    renderRedirect = () => {
        if(this.state.redirect) {
            return <Redirect to={{
                pathname: '/admin-dashboard',
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin
                }
            }}/>
        }
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }


    getVolunteers = () => {

        let live = 'https://www.operation-portal.com/api/volunteer-list'
        let local = 'http://localhost:5000/api/volunteer-list'
        fetch(local , {
            // method: 'GET',
            headers: {
                'Content-Type': 'application/json',
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
            res = res.volunteers
            if(this.mounted === true){
                this.setState({
                    volunteers: res
                })
            }
            console.log(this.state.volunteers)
        })
        .catch((err) => {
            console.log(err)
        })
    }

    // Sets variable to false when ready to leave page
    componentWillUnmount = () => {
        this.mounted = false
    }
  
    // Will set a variable to true when component is fully mounted
    componentDidMount = () => {
        this.mounted = true
    }

    editVolunteers = () => {
        if(this.state.edit) {
            return (
                <Redirect to={{
                    pathname: '/admin-get-id',
                    state: {
                        jwt: this.state.jwt,
                        loggedin: this.state.loggedin
                    }
                }}/>
            )
        }
    }

    setEdit = () => {
        this.setState({
            edit: true
        })
    }

    profileClicked = (ep) => {
        console.log(ep)
    }

    renderVolunteers = () => {
        if(this.state.volunteers != null){
            const p = this.state.volunteers.map((v, index) => {
                return (
                    <div key={index}>
                        <Card style={{width: '25rem'}}>
                            <Card.Header as='h5'>
                                {v.firstName + " " +  v.lastName}
                            </Card.Header>
                            <Card.Body>
                                <Card.Title>
                                    Information
                                </Card.Title>
                                <Card.Text>
                                    ID: {v.id}<br></br>
                                    Preferred Name: {v.preferredName}<br></br>
                                    Email: {v.email}<br></br>
                                    Phone: {v.phone}<br></br>
                                    Birthday: {v.birthday}<br></br>
                                    <br></br>
                                    Role: {v.role}<br></br>
                                    Weeks Attended: {v.weeksAttended}<br></br>
                                    {/* trainings, languages, picture, bus, class, classes interested, 
                                        ages interested, 
                                     */}
                                    <br></br>
                                    Orientation: {v.orientation ? 'Yes' : 'No'}<br></br>
                                    Blue Shirt: {v.blueShirt  ? 'Yes' : 'No'}<br></br>
                                    Name Tag: {v.nameTag  ? 'Yes' : 'No'}<br></br>
                                    Personal Interview: {v.personalInterviewCompleted  ? 'Yes' : 'No'}<br></br>
                                    Background Check: {v.backgroundCheck  ? 'Yes' : 'No'}<br></br>
                                    Year Started: {v.yearStarted}<br></br>
                                    Can Edit Inventory: {v.canEditInventory  ? 'Yes' : 'No'}<br></br>
                                </Card.Text>
                                <Button variant="primary" onClick={() => {this.profileClicked(v)}}>
                                    Edit Volunteer Profiles
                                </Button>
                            </Card.Body>
                        </Card>
                        
                    </div>
                )
            })
            return (
                <div className="row">
                    {p}
                </div>
            )
        }
    }

    render() {
        
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>

                {this.editVolunteers()}
                <Button variant="primary" size="lg" style={styling.ann} onClick={this.setEdit} className="float-right">
                    Edit Volunteer Profiles
                </Button>

                <h1 style={styling.head}>All Volunteers</h1>

                <div style={styling.outderdiv}>
                    <h4>Edit Profile Instructions:</h4>
                    <p>
                        In order to edit volunteer information, please keep track of their unique ID number when navigating to
                        Edit Volunteer Profiles page. There you will be prompted<br></br>
                        to enter the unique ID number and to update any necessary information.
                    </p>
                </div>
                <div style={styling.deckDiv}>
                    {this.renderVolunteers()}
                </div>
                
            </div>
        )
    }
}


const styling = {
    head: {
        marginBottom: "15px",
        textAlign: "center"
    },
    outderdiv: {
        padding: '20px 20px',
        marginLeft: '75px'
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px',
        marginBottom: '15px'
    },
    table: {
        height: '400px',
        width: '1000px'
    },
    deckDiv: {
        justifyContent: 'center',
        alignContent: 'center',
        outline: 'none',
        border: 'none',
        overflowWrap: 'normal',
        marginLeft:'7%'
    },
    ann: {
        marginTop: '15px',
        marginRight: '15px',
        marginBottom: '15px'
    }
}