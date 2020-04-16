import React, { Component } from 'react'
import { Redirect } from 'react-router-dom'
import { Form, Button, Col} from 'react-bootstrap/'

export class AdminVolunteerEdit extends Component {
    constructor(props){
        super(props)
        this.state = {
            redirect: false,
            jwt: props.location.state.jwt,
            loggedin: props.location.state.loggedin,
            volunteer: props.location.state.volunteer,
            id: props.location.state.volunteer.id,
            year: props.location.state.volunteer.yearStarted,
            orientation: props.location.state.volunteer.orientation,
            personal: props.location.state.volunteer.personalInterviewCompleted,
            background: props.location.state.volunteer.backgroundCheck,
            blue: props.location.state.volunteer.blueShirt,
            nametag: props.location.state.volunteer.nameTag,
            inventory: props.location.state.volunteer.canEditInventory,
            role: props.location.state.volunteer.role,
            roleupdate: -1,
            finished: false
        }
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    componentDidMount() {
        this.mounted = true
    }

    componentWillUnmount() {
        this.mounted = false
    }

    editProfile = () => {
        let local = 'http://localhost:5000/api/volunteer-records-edit' 
        let live = 'https://www.operation-portal.com/api/volunteer-records-edit'
        try{
            fetch('/api/volunteer-records-edit' , {
                method: "POST",
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                },
                body: JSON.stringify({
                    id: this.state.id,
                    orientation: this.state.orientation,
                    blueShirt: this.state.blue,
                    nameTag: this.state.nametag,
                    personalInterviewCompleted: this.state.personal,
                    backgroundCheck: this.state.background,
                    yearStarted: this.state.year,
                    canEditInventory: this.state.inventory
                })
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201)){
                    console.log("profile edit successfull")
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500)){
                    console.log("profile edit unsuccessful")
                }
            })
            .then((data) => {
                if(data != null) {
                    this.setState({
                        redirect: true
                    })
                }
            })
        }
        catch(e) {
            console.log("Did not connect")
        }
    }

    renderRedirect = () => {
        if(this.state.redirect){
            return (
                <Redirect to={{
                    pathname: '/admin-volunteer-list',
                    state: {
                        jwt: this.state.jwt,
                        loggedin: this.state.loggedin
                    }
                }}/>
            )
        }
    }

    setOrientation = () => {
        this.setState({
            orientation: !this.state.orientation
        })

    }

    setInventory = () => {
        this.setState({
            inventory: !this.state.inventory
        })

    }

    setPersonal = () => {
        this.setState({
            personal: !this.state.personal
        })

    }

    setBackground = () => {
        this.setState({
            background: !this.state.background
        })
    }

    setBlue = () => {
        this.setState({
            blue: !this.state.blue
        })
    }

    setNametag = () => {
        this.setState({
            nametag: !this.state.nametag
        })
    }

    getRoleNum = (vol) => {
        if(vol.role === "Volunteer") {
            return 1
        }
        else if(vol.role === "VolunteerCaptain") {
            return 2
        }
        else if(vol.role === "BusDriver") {
            return 3
        }
        else if(vol.role === "Staff") {
            return 4
        }
    }

    checkRoleNum = (i) => {
        if(i === 1) {
            return "Volunteer"
        }
        else if(i === 2) {
            return "VolunteerCaptain"
        }
        else if(i === 3) {
            return "BusDriver"
        }
        else if(i === 4) {
            return "Staff"
        }
    }

    getNewRole = (e) => {
        this.setState({
            roleupdate: Number.parseInt(e.target.value)
        })
        console.log(this.state.roleupdate)
    }

    assignRole = () => {
        var check = this.checkRoleNum(this.state.roleupdate)
        console.log(check)
        console.log(this.state.role)
        if(this.state.roleupdate > 0) {
            try {
                fetch('api/role-edit' , {
                    method: "POST",
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${this.state.jwt}`
                    },
                    body: JSON.stringify({
                        'id': this.state.id,
                        'role': check
                    })
                })
                .then((res) => {
                    console.log(res.status)
                    if((res.status === 200 || res.status === 201)){
                        console.log("role assign successfull")
                        // return this.setState({
                        //     redirect: true
                        // })
                        return res.text()
                    }
                    else if((res.status === 401 || res.status === 400 || res.status === 500)){
                        console.log("role assign unsuccessful")
                        // return (
                        //     this.setState({
                        //         redirect: false
                        //     })
                        // )
                        return res.text()
                    }
                })
                .then((data) => {
                    this.editProfile()
                })
            }
            catch(e) {
                console.log(e)
            }
        }
        else if(this.state.roleupdate < 0) {
            this.editProfile()
        }
        

    }


    showVolunteer = () => {
        const vol = this.state.volunteer
        var role = this.getRoleNum(vol)
        if(vol.trainings != undefined) {
            var train = vol.trainings.map((details) => {
                return (
                    details.name + ' | '
                )
            })
        }
        if(vol.languages != undefined) {
            var language = vol.languages.map((details) => {
                return (
                    details + ' | ' 
                )
            })
        }
        return (
            <div>
                <h2>Viewing {vol.firstName + " " + vol.lastName}</h2>
                <hr></hr>
                <Form.Row>
                    <Form.Group as={Col}>
                        <Form.Label><b>ID</b></Form.Label>
                        <Form.Control plaintext readOnly defaultValue={vol.id} />
                    </Form.Group>

                    <Form.Group as={Col}>
                        <Form.Label><b>First Name</b></Form.Label>
                        <Form.Control plaintext readOnly defaultValue={vol.firstName} />
                    </Form.Group>

                    <Form.Group as={Col}>
                        <Form.Label><b>Last Name</b></Form.Label>
                        <Form.Control plaintext readOnly defaultValue={vol.lastName} />
                    </Form.Group>

                    <Form.Group as={Col}>
                        <Form.Label><b>Preferred Name</b></Form.Label>
                        <Form.Control plaintext readOnly defaultValue={vol.preferredName} />
                    </Form.Group>  

                    <Form.Group as={Col}>
                        <Form.Label><b>Role</b></Form.Label>
                        <Form.Control plaintext readOnly defaultValue={'Current: ' + vol.role} />
                        <Form.Control as="select" onChange={this.getNewRole}>
                            <option value={-1}>Current</option>
                            <option value={1}>Volunteer</option>
                            <option value={2}>Volunteer Captain</option>
                            <option value={3}>Bus Driver</option>
                            <option value={4}>Staff</option>
                        </Form.Control>
                    </Form.Group> 
                </Form.Row>

                <Form.Row>
                    <Form.Group as={Col}>
                        <Form.Label><b>Email</b></Form.Label>
                        <Form.Control plaintext readOnly defaultValue={vol.email} />
                    </Form.Group>  

                    <Form.Group as={Col}>
                        <Form.Label><b>Phone</b></Form.Label>
                        <Form.Control plaintext readOnly defaultValue={vol.phone} />
                    </Form.Group>  

                    <Form.Group as={Col}>
                        <Form.Label><b>Birthday</b></Form.Label>
                        <Form.Control plaintext readOnly defaultValue={vol.birthday} />
                    </Form.Group>  

                    <Form.Group as={Col}>
                        <Form.Label><b>Affiliation</b></Form.Label>
                        <Form.Control plaintext readOnly defaultValue={vol.affiliation} />
                    </Form.Group> 
                    

                    <Form.Group as={Col}>
                        <Form.Label><b>Weeks Attended</b></Form.Label>
                        <Form.Control plaintext readOnly defaultValue={vol.weeksAttended} />
                    </Form.Group> 

                </Form.Row>

                <Form.Row>
                    <Form.Group as={Col}>
                        <Form.Label><b>Trainings</b></Form.Label>
                        <p>{train}</p>
                    </Form.Group>

                    <Form.Group as={Col}>
                        <Form.Label><b>Languages</b></Form.Label>
                        <p>{language}</p>
                    </Form.Group>
                </Form.Row>

                <h2>Edit Information</h2>
                <hr></hr>

                <Form.Row>
                    <Form.Group style={{marginRight: "50px"}}>
                        <Form.Label as="legend">
                            <b>Orientation</b>
                        </Form.Label>
                        <Col sm={10} style={{marginTop: '7px'}}>
                            <Form.Check
                                type="checkbox"
                                label="Yes"
                                name="formHorizontalRadios"
                                id="formHorizontalRadios1"
                                onChange={this.setOrientation}
                                checked={this.state.orientation ? true : false}
                            />
                        </Col>
                    </Form.Group>

                    <Form.Group style={{marginRight: "50px"}}>
                        <Form.Label as="legend">
                            <b>Personal Interview Completed</b>
                        </Form.Label>
                        <Col sm={10} style={{marginTop: '7px'}}>
                            <Form.Check
                                type="checkbox"
                                label="Yes"
                                name="formHorizontalRadios"
                                id="formHorizontalRadios1"
                                onChange={this.setPersonal}
                                checked={this.state.personal ? true : false}
                            />
                        </Col>
                    </Form.Group>
                    
                    <Form.Group style={{marginRight: "50px"}}>
                        <Form.Label as="legend">
                            <b>Background Check</b>
                        </Form.Label>
                        <Col sm={10} style={{marginTop: '7px'}}>
                            <Form.Check
                                type="checkbox"
                                label="Yes"
                                name="formHorizontalRadios"
                                id="formHorizontalRadios1"
                                onChange={this.setBackground}
                                checked={this.state.background ? true : false}
                            />
                        </Col>
                    </Form.Group>

                    <Form.Group style={{marginRight: "50px"}}>
                        <Form.Label as="legend">
                            <b>Blue Shirt</b>
                        </Form.Label>
                        <Col sm={10} style={{marginTop: '7px'}}>
                            <Form.Check
                                type="checkbox"
                                label="Yes"
                                name="formHorizontalRadios"
                                id="formHorizontalRadios1"
                                onChange={this.setBlue}
                                checked={this.state.blue ? true : false}
                            />
                        </Col>
                    </Form.Group>

                    <Form.Group style={{marginRight: "50px"}}>
                        <Form.Label as="legend">
                            <b>Name Tag</b>
                        </Form.Label>
                        <Col sm={10} style={{marginTop: '7px'}}>
                            <Form.Check
                                type="checkbox"
                                label="Yes"
                                name="formHorizontalRadios"
                                id="formHorizontalRadios1"
                                onChange={this.setNametag}
                                checked={this.state.nametag ? true : false}
                            />
                        </Col>
                    </Form.Group>

                    <Form.Group style={{marginRight: "50px"}}>
                        <Form.Label as="legend">
                            <b>Can Edit Inventory</b>
                        </Form.Label>
                        <Col sm={10} style={{marginTop: '7px'}}>
                            <Form.Check
                                type="checkbox"
                                label="Yes"
                                name="formHorizontalRadios"
                                id="formHorizontalRadios1"
                                onChange={this.setInventory}
                                checked={this.state.inventory ? true : false}
                            />
                        </Col>
                    </Form.Group>

                    <Form.Group as={Col}>
                        <Form.Label><b>Year Started</b></Form.Label>
                        <Form.Control plaintext readOnly defaultValue={vol.yearStarted} />
                    </Form.Group> 
                </Form.Row>

                <Button variant="link" variant="primary" size="lg" onClick={this.assignRole}>
                    Submit
                </Button>
            </div>
        )
    }

    

    render() {
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to View Volunteers
                </Button>
                <div style={styling.outderdiv}>
                    {this.showVolunteer()}
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
        padding: '20px 20px'
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px',
        marginBottom: '15px'
    },
    volunteer: {

    }
}