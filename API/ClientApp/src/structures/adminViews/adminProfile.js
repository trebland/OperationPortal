import React, { Component } from 'react'
// import Form from 'react-bootstrap/Form'
import { Button, Form, Col, Row } from 'react-bootstrap'
import { Redirect } from 'react-router-dom'

export class AdminProfile extends Component {
    constructor(props) {
        super(props)
        this.state = {
            redirectDash: false,
            jwt: props.location.state.jwt,
            loggedin: props.location.state.loggedin,
            retrievedU: false,
            user: []
        }
        this.getUser()
    }

    setRedirectDash = () => {
        this.setState({
            redirectDash: true
        })
    }

    renderRedirect = () => {
        if(this.state.redirectDash) {
            return <Redirect to={{
                    pathname: '/admin-dashboard',
                    state: {
                        jwt: this.state.jwt,
                        loggedin: this.state.loggedin
                    }
                }}
            />
        }
    }

    getUser = () => {
        try {
            fetch('api/auth/user' , {
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
                    console.log('user retrieval successful')
                    this.setState({
                        retrievedU: true
                    })
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('user retrieval failed')
                    this.setState({
                        retrievedU: false
                    })
                    return res.text()
                }
            })
            .then((data) => {
                console.log(data)
                if(this.state.retrievedU) {
                    var res = JSON.parse(data)
                    console.log(res)
                    // this.setState({
                    //     user: 
                    // })
                }
            })
        }
        catch(e) {
            console.log(e)
        }
    }

    renderProfile = () => {
        return (
            <div>
                <Form>
                    <Form.Row>
                        <Form.Group as={Col}>
                        <Form.Label>First Name</Form.Label>
                        <Form.Control type="text" placeholder="First Name" />
                        </Form.Group>

                        <Form.Group as={Col}>
                        <Form.Label>Last Name</Form.Label>
                        <Form.Control type="text" placeholder="Last Name" />
                        </Form.Group>

                        <Form.Group as={Col}>
                        <Form.Label>Preferred Name</Form.Label>
                        <Form.Control type="text" placeholder="Preferred Name" />
                        </Form.Group>
                    </Form.Row>

                    <Form.Row>
                        <Form.Group as={Col}>
                        <Form.Label>Email</Form.Label>
                        <Form.Control type="email" placeholder="Email" />
                        </Form.Group>

                        <Form.Group as={Col}>
                        <Form.Label>Phone Number</Form.Label>
                        <Form.Control type="number" placeholder="###-###-####" />
                        </Form.Group>

                    </Form.Row>

                    <br/>

                    <Form.Row>
                        <Form.Group style={{marginRight: "50px"}}>
                            <Form.Check type="checkbox" label="Orientation" />
                        </Form.Group>
                        
                        <Form.Group style={{marginRight: "50px"}}>
                            <Form.Check type="checkbox" label="Contact When Short" />
                        </Form.Group>

                        <Form.Group style={{marginRight: "50px"}}>
                            <Form.Check type="checkbox" label="Background Check" />
                        </Form.Group>

                        <Form.Group style={{marginRight: "50px"}}>
                            <Form.Check type="checkbox" label="Blue Shirt" />
                        </Form.Group>

                        <Form.Group style={{marginRight: "50px"}}>
                            <Form.Check type="checkbox" label="Name Tag" />
                        </Form.Group>
                    </Form.Row>

                    <br/>

                    <Button variant="primary" type="submit">
                        Submit
                    </Button>
                </Form>
            </div>
        )
    }

    render() {
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirectDash}>
                    Back to Dashboard
                </Button>

                <div style={styling.header}>
                    <h1>Edit Profile</h1>
                </div>

                <div style={styling.form}>
                    {this.renderProfile()}
                </div>
            </div>
        )
    }
}

const styling = {
    head: {
        textAlign: "center"
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px',
        marginBottom: '15px'
    },
    header: {
        textAlign: 'center',
        justifyContent: 'center',
        marginTop: '40px'
    },
    form: {
        padding: '20px 20px'
    }
}

// POST api/volunteer-profile-edit
// Roles accessed by: volunteers, volunteer captains, bus drivers, staff
// Input:
// {“id”:“affiliation”: “string”, “referral”: “string”, “languages”: [“string”], “newsletter”: “bool”, “contactWhenShort”: “bool”, “phone”: “string”, “firstName”: “string”, “lastName”: “string”, “preferredName”:”string”, “birthday”:datetime,”picture”:byte[]}
// Output:
// On success {“error”:”string”, “volunteer”:{“firstName”:”string”, “preferredName”:”string”, “lastName”:”string”, “orientation”: “bool”, “training”: [{“name”: “string”}], “affiliation”: “string”, “referral”: “string”, “languages”: [“language”: “string”], “newsletter”: “bool”, “contactWhenShort”: “bool”, “phone”: “string”, “email”: “string”,“blueShirt”:bool, “nametag”:bool, “personalInterviewCompleted”:bool, “backgroundCheck”:bool, “yearStarted”:int, “canEditInventory”:bool, “picture”:byte[], “birthday”:DateTime}}
// On failure {“error”:”string”}



// GET api/auth/user
// Roles accessed by: all logged-in users
// Input: 
// None
// Output:
// On success: {“error”:””, “profile”:{"id": int, "firstName": "string", "lastName": "string", "role": "string", “CanEditInventory”:bool}, “CheckedIn”: bool, “classes”: [{“id”:int, “name”:“string”, “numstudents”:int, “teacherId”:int, “teacherName”:”string”}], “buses”: [{"id": int, "driverId": int,  "driverName": "string", "name": "string", "route": "string",  "lastOilChange": DateTime, "lastTireChange": DateTime, "lastMaintenance": DateTime}]}}
// On failure: {“error”:”string”}
