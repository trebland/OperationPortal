import React, { Component } from 'react'
// import Form from 'react-bootstrap/Form'
import { Button, Form, Col } from 'react-bootstrap'
import { Redirect } from 'react-router-dom'

export class UserProfile extends Component {
    constructor(props) {
        super(props)
        this.state = {
            redirectDash: false,
            jwt: props.location.state.jwt,
            role: props.location.state.role,
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
            pictureResult: '',
            id: null,
            updated: false,
            updateResult: '',
            languages: null,
            language_string: ''
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
        this.handleLanguages = this.handleLanguages.bind(this)
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
                    pathname: '/dashboard',
                    state: {
                        jwt: this.state.jwt,
                        loggedin: this.state.loggedin,
                        role: this.state.role
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

    handleLanguages = (e) => {
        this.setState({
            language_string: e.target.value.replace(/[^\w\s]/gi, '')
        })
        console.log(this.state.language_string)
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
                    console.log(res)
                    this.setState({
                        firstname: res.firstName,
                        lastname: res.lastName,
                        contactWhenShort: res.contactWhenShort,
                        newsletter: res.newsletter,
                        preferredname: res.preferredName,
                        phone: res.phone,
                        birthday: res.birthday,
                        referral: res.referral,
                        affiliation: res.affiliation,
                        picture: res.picture,
                        id: res.id,
                        languages: res.languages
                        // “languages”: [“string”]
                    })
                }
            })
        }
        catch(e) {
            console.log(e)
        }
    }

    onSubmit = () => {
        var c = this.state.language_string.replace(/ /g, '').toString()
        console.log(c)
        this.state.languages.push(c)
        console.log(this.state.languages)
        try {
            fetch('api/volunteer-profile-edit' , {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                },
                body: JSON.stringify(
                    {
                        'id': this.state.id,
                        'affiliation': this.state.affiliation,
                        'referral': this.state.referral,
                        'languages': this.state.languages,
                        'newsletter': this.state.newsletter,
                        'contactWhenShort': this.state.contactWhenShort,
                        'phone': this.state.phone,
                        'firstName': this.state.firstname,
                        'lastName': this.state.lastname,
                        'preferredName': this.state.preferredname,
                        'birthday': this.state.birthday,
                        'picture': this.state.picture
                    }
                )
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('Update profile successful')
                    this.setState({
                        updated: true,
                        updateResult: 'Profile was saved!'
                    })
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('Update profile unsuccessful')
                    this.setState({
                        updated: false
                    })
                    return res.text()
                }
            })
            .then((data) => {
                if(this.state.updated === false) {
                    var res = JSON.parse(data)
                    console.log(res)
                    this.setState({
                        updateResult: 'Profile not saved, please include a picture.'
                    })
                    console.log(this.state.updateResult)
                }
                else if(this.state.updated) {
                    this.setState({
                        language_string: ''
                    })
                }
            })
        }
        catch(e) {
            console.log(e)
        }
    }



    renderProfile = () => {
        if(this.state.languages != undefined) {
            var language = this.state.languages.map((details) => {
                return (
                    details + ' | ' 
                )
            })
        }
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
                            <Form.Control type="text" placeholder= '##########' maxLength='10' value={this.state.phone} onChange={this.handlePhoneChange}/>
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

                    <Form.Row>
                        <Form.Group>
                            <Form.Label>Languages</Form.Label>
                            <Form.Control type="text" placeholder="Language" maxLength="13" value={this.state.language_string} onChange={this.handleLanguages}/>
                            <Form.Text>
                                Please add one language at a time then click save.<br></br>
                                <b>Current Languages: </b>{language}
                            </Form.Text>
                        </Form.Group>
                    </Form.Row>

                    {/* <Form.Label>Profile Picture</Form.Label> */}
                    <div className='custom-file' style={{width: '400px'}}>
                        
                        <input type="file" className="custom-file-input" id="picture" accept=".jpg,.jpeg,.png" onChange={this.handlePictureChange}/>
                        <Form.Label className="custom-file-label">Choose Picture</Form.Label>
                        <p style={{ textAlign: 'center' }}>{this.state.pictureResult}</p>
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
                </Form>
                <div>
                    <center>
                        {this.renderRedirect()}
                        <Button variant="link" variant="primary" size="lg" onClick={this.onSubmit} style={{ justifyContent: 'center', width: '80%', marginBottom: '20px' }}>
                            Save
                        </Button>
                        <p style={this.state.updated ? { color: 'green' } : { color: 'red' }}>{this.state.updateResult}</p>
                    </center>
                </div>
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