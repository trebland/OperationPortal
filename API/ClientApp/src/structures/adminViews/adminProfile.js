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
            user: [],
            firstname: '',
            lastname: '',
            preferredname: '',
            regexp : /^[0-9\b]+$/,
            phone: '',
            referral: '',
            affiliation: '',
            birthday: '',
            newsletter: null,
            contactWhenShort: null,
            picture: null,
            pictureResult: ''
        }
        this.getUser()

        this.setContact = this.setContact.bind(this)
        this.setNewsletter = this.setNewsletter.bind(this)
        this.handleFirstnameChange = this.handleFirstnameChange.bind(this)
        this.handleLastnameChange = this.handleLastnameChange.bind(this)
        this.handlePreferrednameChange = this.handlePreferrednameChange.bind(this)
        this.handlePhoneChange = this.handlePhoneChange.bind(this)
        this.handleReferralChange = this.handleReferralChange.bind(this)
        this.handleAffiliationChange = this.handleAffiliationChange.bind(this)
        this.handleBirthdayChange = this.handleBirthdayChange.bind(this)
        this.handlePictureChange = this.handlePictureChange.bind(this)
    }

    componentDidMount() {
        this.mounted = true
    }

    componentWillUnmount() {
        this.mounted = false
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

    setContact = () => {
        this.setState({
            contactWhenShort: !this.state.contactWhenShort
        })
        console.log(this.state.contactWhenShort)
    }

    setNewsletter = () => {
        this.setState({
            newsletter: !this.state.newsletter
        })
        console.log(this.state.newsletter)
    }

    handleFirstnameChange = (e) => {
        this.setState({
            firstname: e.target.value
        })
        console.log(this.state.firstname)
    }

    handleLastnameChange = (e) => {
        this.setState({
            lastname: e.target.value
        })
        console.log(this.state.lastname)
    }
    
    handlePreferrednameChange = (e) => {
        this.setState({
            preferredname: e.target.value
        })
        console.log(this.state.preferredname)
    }

    handlePhoneChange = (e) => {
        let idd = e.target.value
        if(idd === '' || this.state.regexp.test(idd)) {
            this.setState({
                phone: idd,
            })
        }
        console.log(this.state.phone)
    }

    handleReferralChange = (e) => {
        this.setState({
            referral: e.target.value
        })
        console.log(this.state.referral)
    }

    handleAffiliationChange = (e) => {
        this.setState({
            affiliation: e.target.value
        })
        console.log(this.state.affiliation)
    }

    handleBirthdayChange = (e) => {
        this.setState({
            birthday: e.target.value
        })
        console.log(this.state.birthday)
    }

    parsePicture = (file) => {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();

            reader.onload = (event) => {
                resolve(event.target.result);
            };

            reader.onerror = (err) => {
                reject(err);
            };

            reader.readAsDataURL(file); 
        });
    }

    handlePictureChange = (e) => {
        const file = e.target.files[0];

        this.parsePicture(file).then((result) => {
            let pic = (result.split(","))[1];
            this.setState({
                pictureResult: file.name + ' selected',
                picture: pic
            })
        });
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
                if(this.state.retrievedU) {
                    var res = JSON.parse(data)
                    res = res.profile
                    this.setState({
                        user: res,
                        contactWhenShort: res.contactWhenShort,
                        newsletter: res.newsletter
                    })
                    console.log(this.state.user)
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
                            <Form.Control type="text" placeholder="First Name" value={this.state.firstname} onChange={this.handleFirstnameChange}/>
                        </Form.Group>

                        <Form.Group as={Col}>
                            <Form.Label>Last Name</Form.Label>
                            <Form.Control type="text" placeholder="Last Name" value={this.state.lastname} onChange={this.handleLastnameChange}/>
                        </Form.Group>

                        <Form.Group as={Col}>
                            <Form.Label>Preferred Name</Form.Label>
                            <Form.Control type="text" placeholder="Preferred Name" value={this.state.preferredname} onChange={this.handlePreferrednameChange}/>
                        </Form.Group>
                    </Form.Row>

                    <Form.Row>
                        <Form.Group as={Col}>
                            <Form.Label>Phone Number</Form.Label>
                            <Form.Control type="text" placeholder="###-###-####" maxLength='10' value={this.state.phone} onChange={this.handlePhoneChange}/>
                            <Form.Text>
                            Please format with no spaces, parenthesis, or dashes. Ex: ##########
                        </Form.Text>
                        </Form.Group>

                        <Form.Group as={Col}>
                            <Form.Label>Birthday</Form.Label>
                            <Form.Control type="date" placeholder="Birthday" onChange={this.handleBirthdayChange}/>
                        </Form.Group>

                        <Form.Group as={Col}>
                            <Form.Label>Referral</Form.Label>
                            <Form.Control type="text" placeholder="Referral" value={this.state.referral} onChange={this.handleReferralChange}/>
                        </Form.Group>

                        <Form.Group as={Col}>
                            <Form.Label>Affiliation</Form.Label>
                            <Form.Control type="text" placeholder="Affiliation" value={this.state.affiliation} onChange={this.handleAffiliationChange}/>
                        </Form.Group>
                        {/* {“id” ”picture”:byte[], languages} */}

                    </Form.Row>

                    {/* <Form.Label>Profile Picture</Form.Label> */}
                    <div className='custom-file' style={{width: '400px'}}>
                        
                        <input type="file" className="custom-file-input" id="picture" accept=".jpg,.jpeg,.png" onChange={this.handlePictureChange}/>
                        <Form.Label className="custom-file-label">Choose Picture</Form.Label>
                        <p style={{ textAlign: 'center' }}></p>
                    </div>

                    <br></br>
                    <br></br>

                    <Form.Row>
                        <Form.Group style={{marginRight: "50px", marginLeft: '10px'}}>
                            <Form.Label>Newsletter</Form.Label>
                            <Form.Check 
                                type="checkbox" 
                                label="Yes"
                                checked={this.state.newsletter ? true : false} 
                                onChange={this.setNewsletter}
                            />
                        </Form.Group>
                        
                        <Form.Group style={{marginRight: "50px"}}>
                            <Form.Label>Contact When Short</Form.Label>
                            <Form.Check 
                                type="checkbox" 
                                label="Yes" 
                                checked={this.state.contactWhenShort ? true : false}
                                onChange={this.setContact}
                            />
                        </Form.Group>

                    </Form.Row>
                    
                    <br></br>
                    <br></br>

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
