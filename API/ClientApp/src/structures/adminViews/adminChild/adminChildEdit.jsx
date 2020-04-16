import React, { Component } from 'react';
import { Form, FormControl, FormGroup, FormLabel, Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import DatePicker from "react-datepicker";

import "react-datepicker/dist/react-datepicker.css";

export class AdminChildEdit extends Component {
    constructor(props) {
        super(props)

        if (props.location.state != null) {
            this.state = {
                jwt: props.location.state.jwt,
                loggedin: props.location.state.loggedin,
                firstName: '',
                lastName: '',
                preferredName: '',
                contactNumber: '',
                parentName: '',
                busId: 0,
                birthday: null,
                gender: '',
                grade: 0,
                parentalWaiver: false,
                classId: 0,
                picture: null,
                pictureResult: '',
                busWaiver: false,
                haircutWaiver: false,
                parentalEmailOptIn: false,
                orangeShirtStatus: 0,
                redirect: false,
                result: '',
                success: false,
                getSuccess: false,
                getBusesSuccess: false,
                getClassesSuccess: false,
                buses: [],
                classes: []
            };
            this.handleFirstNameChange = this.handleFirstNameChange.bind(this);
            this.handleLastNameChange = this.handleLastNameChange.bind(this);
            this.handlePreferredNameChange = this.handlePreferredNameChange.bind(this);
            this.handleContactNumberChange = this.handleContactNumberChange.bind(this);
            this.handleParentNameChange = this.handleParentNameChange.bind(this);
            this.handleBusIdChange = this.handleBusIdChange.bind(this);
            this.handleBirthdayChange = this.handleBirthdayChange.bind(this);
            this.handleGenderChange = this.handleGenderChange.bind(this);
            this.handleGradeChange = this.handleGradeChange.bind(this);
            this.handleParentalWaiverChange = this.handleParentalWaiverChange.bind(this);
            this.handleClassIdChange = this.handleClassIdChange.bind(this);
            this.handlePictureChange = this.handlePictureChange.bind(this);
            this.handleBusWaiverChange = this.handleBusWaiverChange.bind(this);
            this.handleHaircutWaiverChange = this.handleHaircutWaiverChange.bind(this);
            this.handleParentalEmailOptInChange = this.handleParentalEmailOptInChange.bind(this);
            this.handleOrangeShirtStatusChange = this.handleOrangeShirtStatusChange.bind(this);
            this.onSubmit = this.onSubmit.bind(this);

            if (props.match.params.id) {
                this.getChild();
                this.getBuses();
                this.getClasses();
            }
        }
        else {
            this.state = {
                loggedin: false,
            }
        }
    }

    componentDidMount() {
        this.mounted = true
    }

    handleFirstNameChange = (e) => {
        this.setState({
            firstName: e.target.value
        })
    }

    handleLastNameChange = (e) => {
        this.setState({
            lastName: e.target.value
        })
    }

    handlePreferredNameChange = (e) => {
        this.setState({
            preferredName: e.target.value
        })
    }

    handleContactNumberChange = (e) => {
        this.setState({
            contactNumber: e.target.value
        })
    }

    handleParentNameChange = (e) => {
        this.setState({
            parentName: e.target.value
        })
    }

    handleBusIdChange = (e) => {
        this.setState({
            busId: e.target.value
        })
    }

    handleBirthdayChange = (date) => {
        this.setState({
            birthday: date
        })
    }

    handleGenderChange = (e) => {
        this.setState({
            gender: e.target.value
        })
    }

    handleGradeChange = (e) => {
        this.setState({
            grade: e.target.value
        })
    }

    handleParentalWaiverChange = (e) => {
        this.setState({
            parentalWaiver: e.target.checked
        })
    }

    handleClassIdChange = (e) => {
        this.setState({
            classId: e.target.value
        })
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

    handleBusWaiverChange = (e) => {
        this.setState({
            busWaiver: e.target.checked
        })
    }

    handleHaircutWaiverChange = (e) => {
        this.setState({
            haircutWaiver: e.target.checked
        })
    }

    handleParentalEmailOptInChange = (e) => {
        console.log(e.target.checked)
        this.setState({
            parentalEmailOptIn: e.target.checked
        })
    }

    handleOrangeShirtStatusChange = (e) => {
        this.setState({
            orangeShirtStatus: e.target.value
        })
    }

    // Gets the current information about the training so that the fields can be prefilled
    getChild = () => {
        fetch('/api/child?id=' + this.props.match.params.id, {
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.state.jwt}`
            },
        })
        .then((res) => {
            if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                this.setState({
                    getSuccess: true,
                })
                return res.json()
            }
            else if ((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true) {
                this.setState({
                    getSuccess: false,
                })
                return
            }
        })
        .then((data) => {
            if (this.state.getSuccess) {
                this.setState({
                    firstName: data.firstName,
                    lastName: data.lastName,
                    preferredName: data.preferredName,
                    contactNumber: data.contactNumber,
                    parentName: data.parentName,
                    busId: data.busId,
                    birthday: data.birthday,
                    gender: data.gender,
                    grade: data.grade,
                    parentalWaiver: data.parentalWaiver,
                    classId: data.classId,
                    picture: data.picture,
                    busWaiver: data.busWaiver,
                    haircutWaiver: data.haircutWaiver,
                    parentalEmailOptIn: data.parentalEmailOptIn,
                    orangeShirtStatus: data.orangeShirtStatus
                })
            }
        })
    }

    getBuses = () => {
        fetch('/api/bus-list', {
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.state.jwt}`
            },
        })
        .then((res) => {
            if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                this.setState({
                    getBusesSuccess: true,
                })
                return res.json()
            }
            else if ((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true) {
                this.setState({
                    getBusesSuccess: false,
                })
                return
            }
        })
        .then((data) => {
            if (this.state.getBusesSuccess) {
                this.setState({
                    buses: data.buses
                })
            }
        })
    }

    getClasses = () => {
        fetch('/api/class-list', {
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.state.jwt}`
            },
        })
        .then((res) => {
            if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                this.setState({
                    getClassesSuccess: true,
                })
                return res.json()
            }
            else if ((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true) {
                this.setState({
                    getClassesSuccess: false,
                })
                return
            }
        })
        .then((data) => {
            if (this.state.getClassesSuccess) {
                this.setState({
                    classes: data.classes
                })
            }
        })
    }

    onSubmit = (e) => {
        e.preventDefault();

        try {
            fetch('/api/child-edit', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                },
                body: JSON.stringify({
                    Id: this.props.match.params.id,
                    FirstName: this.state.firstName,
                    LastName: this.state.lastName,
                    PreferredName: this.state.preferredName,
                    ContactNumber: this.state.contactNumber,
                    ParentName: this.state.parentName,
                    BusId: this.state.busId,
                    Birthday: this.state.birthday,
                    Gender: this.state.gender,
                    Grade: this.state.grade,
                    ParentalWaiver: this.state.parentalWaiver,
                    ClassId: this.state.classId,
                    Picture: this.state.picture,
                    BusWaiver: this.state.busWaiver,
                    HaircutWaiver: this.state.haircutWaiver,
                    ParentalEmailOptIn: this.state.parentalEmailOptIn,
                    OrangeShirtStatus: this.state.orangeShirtStatus, 
                })
            })
            .then((res) => {
                if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                    this.setState({
                        result: 'Edit saved successfully!',
                        success: true,
                    })
                    return
                }
                else if ((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true) {
                    this.setState({
                        success: false,
                    })
                    return res.json()
                }
            })
            .then((data) => {
                if (!this.state.success) {
                    this.setState({
                        result: data.error
                    })
                }
            })
        }
        catch (e) {
            console.log(e);
        }
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    renderBuses = () => {
        if (this.state.buses != null) {
            const p = this.state.buses.map((b, index) => {
                return <option key={index} value={b.id}>{b.name}</option>
            })
            return p;
        }
    }

    renderClasses = () => {
        if (this.state.classes != null) {
            const p = this.state.classes.map((c, index) => {
                return <option key={index} value={c.id}>{c.name}</option>
            })
            return p;
        }
    }

    renderGrades = () => {
        var range = [];

        for (var i = 0; i <= 12; i++) {
            range.push(i);
        }

        const p = range.map((i, index) => {
            return <option key={index} value={i}>{i ? i : 'N/A'}</option>
        })

        return p;
    }

    renderRedirect = () => {
        if (this.state.redirect) {
            return <Redirect to={{
                pathname: '/admin-child-list',
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin
                }
            }} />
        }
    }

    render() {
        if (!this.state.loggedin) {
            return <Redirect to={{
                pathname: '/login',
            }} />
        }
        if (!this.props.match.params.id || !this.state.getSuccess) {
            return (
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to List
                </Button>
            )
        }
        return (
            <div>
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to List
                </Button>
                <div style={styling.header}>
                    <h1>Edit Child/View Details</h1>
                </div>
                <div className="box" style={styling.outerDiv}>
                    <Form style={styling.formDiv}>
                        <FormGroup>
                            <FormLabel>First Name</FormLabel>
                            <FormControl type="text" placeholder="First Name" value={this.state.firstName} onChange={this.handleFirstNameChange} />
                        </FormGroup>
                        <FormGroup>
                            <FormLabel>Preferred Name</FormLabel>
                            <FormControl type="text" placeholder="Preferred Name" value={this.state.preferredName} onChange={this.handlePreferredNameChange} />
                        </FormGroup>
                        <FormGroup>
                            <FormLabel>Last Name</FormLabel>
                            <FormControl type="text" placeholder="Last Name" value={this.state.lastName} onChange={this.handleLastNameChange} />
                        </FormGroup>
                        <FormGroup>
                            <FormLabel>Parent Name</FormLabel>
                            <FormControl type="text" placeholder="Parent Name" value={this.state.parentName} onChange={this.handleParentNameChange} />
                        </FormGroup>
                        <FormGroup>
                            <FormLabel>Contact Number</FormLabel>
                            <FormControl type="telephone" placeholder="Contact Number" value={this.state.contactNumber} onChange={this.handleContactNumberChange} />
                        </FormGroup>
                        <FormGroup>
                            <Form.Check inline label="Parental Email Opt-In" checked={this.state.parentalEmailOptIn} onChange={this.handleParentalEmailOptInChange} type="checkbox" />
                        </FormGroup>
                        <FormGroup>
                            <Form.Check inline label="Parental Waiver" checked={this.state.parentalWaiver} onChange={this.handleParentalWaiverChange} type="checkbox" />
                        </FormGroup>
                        <FormGroup>
                            <FormLabel style={{marginRight: '5px'}}>Birthday:  </FormLabel>
                            <DatePicker
                                selected={typeof(this.state.birthday === 'string') ? (this.state.birthday ? new Date(this.state.birthday) : new Date()) : this.state.birthday}
                                onChange={this.handleBirthdayChange}
                                className="form-control"
                            />
                        </FormGroup>
                    </Form>

                    <Form style={styling.formDiv}>
                        <FormGroup>
                            <FormLabel>Bus </FormLabel>
                            <Form.Control as="select" value={this.state.busId} onChange={this.handleBusIdChange}>
                                {this.renderBuses()}
                            </Form.Control>
                        </FormGroup>
                        <FormGroup>
                            <FormLabel>Class </FormLabel>
                            <Form.Control as="select" value={this.state.classId} onChange={this.handleClassIdChange}>
                                {this.renderClasses()}
                            </Form.Control>
                        </FormGroup>
                        <FormGroup>
                            <FormLabel>Gender </FormLabel>
                            <Form.Control as="select" value={this.state.gender} onChange={this.handleGenderChange}>
                                <option value={'Male'}>Male</option>
                                <option value={'Female'}>Female</option>
                                <option value={'Other'}>Other</option>
                            </Form.Control>
                        </FormGroup>
                        <FormGroup>
                            <FormLabel>Grade </FormLabel>
                            <Form.Control as="select" value={this.state.grade} onChange={this.handleGradeChange}>
                                {this.renderGrades()}
                            </Form.Control>
                        </FormGroup>
                        <FormGroup>
                            <FormLabel>Orange Shirt Status </FormLabel>
                            <Form.Control as="select" value={this.state.orangeShirtStatus} onChange={this.handleOrangeShirtStatusChange}>
                                <option value={0}>Pending</option>
                                <option value={1}>Completed</option>
                                <option value={2}>Relinquished</option>
                            </Form.Control>
                        </FormGroup>
                        <FormGroup>
                            <Form.Check inline label="Bus Waiver" checked={this.state.busWaiver} onChange={this.handleBusWaiverChange} type="checkbox" />
                        </FormGroup>
                        <FormGroup>
                            <Form.Check inline label="Haircut Waiver" checked={this.state.haircutWaiver} onChange={this.handleHaircutWaiverChange} type="checkbox" />
                        </FormGroup>
                        <div className='custom-file'>
                            <input type="file" className="custom-file-input" id="picture" accept=".jpg,.jpeg,.png" onChange={this.handlePictureChange} />
                            <FormLabel className="custom-file-label">Choose Picture</FormLabel>
                            <p style={{ textAlign: 'center' }}>{this.state.pictureResult}</p>
                        </div>
                    </Form>
                </div>
                <div>
                    <center>
                        {this.renderRedirect()}
                        <Button variant="link" variant="primary" size="lg" onClick={this.onSubmit} style={{ justifyContent: 'center', width: '80%', marginBottom: '20px' }}>
                            Save
                        </Button>
                        <p style={this.state.success ? { color: 'green' } : { color: 'red' }}>{this.state.result}</p>
                    </center>
                </div>
            </div>
        );
    }
}

const styling = {
    formDiv: {
        width: '40%',
        margin: '5%'
    },
    outerDiv: {
        display: 'flex',
        justifyContent: 'center',
        margin: '8%',
        marginBottom: '2%'
    },
    header: {
        textAlign: 'center',
        justifyContent: 'center',
        marginTop: '40px'
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px'
    }
}