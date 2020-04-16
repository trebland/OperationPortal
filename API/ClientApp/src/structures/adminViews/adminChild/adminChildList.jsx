import React, { Component } from 'react'
import { Form, FormControl, FormGroup, FormLabel, Button, Card} from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import '../cards.css'
import { EditDetailsButton } from '../../customButtons'

export class AdminChildList extends Component {
    constructor(props) {
        super(props)

        if (props.location.state == null) {
            this.state = {
                loggedin: false
            }
            return
        }

        this.state = {
            jwt: props.location.state.jwt,
            loggedin: props.location.state.loggedin,
            redirect: false,
            edit: false,
            editId: 0,
            fullRoster: [],
            roster: [],
            buses: [],
            classes: [],
            name: '',
            age: 0,
            grade: -1,
            gender: '',
            parentalWaiver: 0,
            busWaiver: 0,
            parentalEmailOptIn: 0,
            haircutWaiver: 0,
            checkedIn: 0,
            classId: 0,
            busId: 0,
            orangeShirt: -1,
        };

        this.getChildren();
        this.getBuses();
        this.getClasses();
    }

    calculateAge = (birthday) => {
        var bDate = new Date(birthday);
        var birthYear = bDate.getFullYear();
        var birthMonth = bDate.getMonth();
        var birthDay = bDate.getDate();
        var now = new Date();
        var curYear = now.getFullYear();
        var curMonth = now.getMonth();
        var curDay = now.getDate();
        var diff = curYear - birthYear;
        if (birthMonth > curMonth) diff--;
        else {
            if (birthMonth == curMonth) {
                if (birthDay > curDay) diff--;
            }
        }
        return diff;
    }

    getChildren() {
        fetch('/api/roster', {
            // method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.state.jwt}`
            }
        })
        .then((res) => {
            if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                return res.json()
            }
            else if ((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true) {
                return
            }
        })
        .then((data) => {
            if (this.mounted === true) {

                this.setState({
                    fullRoster: data.fullRoster,
                    roster: data.fullRoster,
                })
            }
        })
        .catch((err) => {
            console.log(err)
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

    handleNameChange = (e) => {
        this.setState({
            name: e.target.value
        })
    }

    handleAgeChange = (e) => {
        const age = parseInt(e.target.value);

        if (isNaN(age))
            return;

        if (age < 0 || age > 100) {
            return;
        }

        this.setState({
            age: age
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

    handleParentalEmailOptInChange = (e) => {
        this.setState({
            parentalEmailOptIn: e.target.value
        })
    }

    handleParentalWaiverChange = (e) => {
        this.setState({
            parentalWaiver: e.target.value
        })
    }

    handleBusWaiverChange = (e) => {
        this.setState({
            busWaiver: e.target.value
        })
    }

    handleHaircutWaiverChange = (e) => {
        this.setState({
            haircutWaiver: e.target.value
        })
    }

    handleCheckedInChange = (e) => {
        this.setState({
            checkedIn: e.target.value
        })
    }

    handleOrangeShirtChange = (e) => {
        this.setState({
            orangeShirt: e.target.value
        })
    }

    handleBusIdChange = (e) => {
        this.setState({
            busId: e.target.value
        })
    }

    handleClassIdChange = (e) => {
        this.setState({
            classId: e.target.value
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

    filter = (fullRoster) => {
        let roster = [...fullRoster];

        if (this.state.name) {
            roster = roster.filter(c =>
                c.firstName.toLowerCase().indexOf(this.state.name.toLowerCase()) != -1
                || c.lastName.toLowerCase().indexOf(this.state.name.toLowerCase()) != -1
                || c.preferredName.toLowerCase().indexOf(this.state.name.toLowerCase()) != -1
            );
        }

        if (this.state.gender) {
            roster = roster.filter(c => c.gender == this.state.gender);
        }

        if (this.state.grade != -1) {
            roster = roster.filter(c => c.grade == this.state.grade);
        }

        if (this.state.age) {
            roster = roster.filter(c => this.calculateAge(c.birthday) == parseInt(this.state.age));
        }

        if (this.state.parentalWaiver) {
            roster = roster.filter(c => this.state.parentalWaiver == 1 ? c.parentalWaiver : !c.parentalWaiver);
        }

        if (this.state.busWaiver) {
            roster = roster.filter(c => this.state.busWaiver == 1 ? c.busWaiver : !c.busWaiver);
        }

        if (this.state.haircutWaiver) {
            roster = roster.filter(c => this.state.haircutWaiver == 1 ? c.haircutWaiver : !c.haircutWaiver);
        }

        if (this.state.parentalEmailOptIn) {
            roster = roster.filter(c => this.state.parentalEmailOptIn == 1 ? c.parentalEmailOptIn : !c.parentalEmailOptIn);
        }

        if (this.state.checkedIn) {
            roster = roster.filter(c => this.state.checkedIn == 1 ? c.checkedIn : !c.checkedIn);
        }

        if (this.state.orangeShirt != -1) {
            roster = roster.filter(c => c.orangeShirt == this.state.orangeShirt);
        }

        if (this.state.classId) {
            roster = roster.filter(c => c.class.id == this.state.classId);
        }

        if (this.state.busId) {
            roster = roster.filter(c => c.bus.id == this.state.busId);
        }

        return roster;
    }

    onFilter = () => {
        if (!this.state.fullRoster || this.state.fullRoster.length == 0)
            return;

        this.setState({
            roster: this.filter(this.state.fullRoster)
        })
    }

    onClearFilter = () => {
        this.setState({
            name: '',
            age: 0,
            grade: -1,
            gender: '',
            parentalWaiver: 0,
            busWaiver: 0,
            parentalEmailOptIn: 0,
            haircutWaiver: 0,
            checkedIn: 0,
            classId: 0,
            busId: 0,
            orangeShirt: -1
        })

        if (this.state.fullRoster && this.state.fullRoster.length > 0) {
            this.setState({
                roster: this.state.fullRoster
            })
        }
    }

    renderRedirect = () => {
        if (this.state.redirect) {
            return <Redirect to={{
                pathname: '/admin-dashboard',
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin
                }
            }} />
        }
        else if (this.state.edit) {
            return <Redirect to={{
                pathname: '/admin-child-edit/' + this.state.editId,
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin
                }
            }} />
        }
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

    renderRoster = () => {
        if (this.state.roster != null) {
            const p = this.state.roster.map((c, index) => {
                return (
                    <div key={index}>
                        <Card style={{ width: '25rem' }}>
                            <Card.Header as='h5'>
                                {(c.preferredName || c.firstName) + ' ' + (c.preferredName ? '(' + c.firstName + ')' : '') + ' ' + c.lastName} <span style={{ fontWeight: 'bold', color: 'red', float: 'right' }}>{c.isSuspended ? 'SUSPENDED' : ''}</span>
                            </Card.Header>
                            <Card.Body>
                                <div style={styling.imgContainer}>
                                    <img style={styling.image} src={c.picture ? `data:image/jpeg;base64,${c.picture}` : 'https://i.imgur.com/tdi3NGag.png'} />
                                </div>

                                <table style={styling.childTable}>
                                    <tbody>
                                        <tr>
                                            <th style={styling.childTH}>Bus: </th>
                                            <td>{(c.bus && c.bus.id) ? c.bus.name : 'Not Assigned'}</td>
                                        </tr>
                                        <tr>
                                            <th style={styling.childTH}>Class: </th>
                                            <td>{(c.class && c.class.id) ? c.class.name : 'Not Assigned'}</td>
                                        </tr>
                                        <tr>
                                            <th style={styling.childTH}>Last Date Attended: </th>
                                            <td>{(new Date(c.lastDateAttended)).toDateString() != 'Mon Jan 01 0001' ? (new Date(c.lastDateAttended)).toDateString() : 'N/A'} </td>
                                        </tr>
                                        <tr>
                                            <th style={styling.childTH}>Gender: </th>
                                            <td>{c.gender || 'None saved'} </td>
                                        </tr>
                                        <tr>
                                            <th style={styling.childTH}>Birthday: </th>
                                            <td>{c.birthday ? (c.birthday.split(' '))[0] + ' (age ' + this.calculateAge(c.birthday) + ')' : 'None saved'} </td>
                                        </tr>
                                        <tr>
                                            <th style={styling.childTH}>Grade: </th>
                                            <td>{c.grade || 'N/A'}</td>
                                        </tr>
                                        <tr>
                                            <th style={styling.childTH}>Parent Name: </th>
                                            <td>{c.parentName || 'None saved'} </td>
                                        </tr>
                                        <tr>
                                            <th style={styling.childTH}>Contact Number: </th>
                                            <td>{c.contactNumber || 'None saved'}</td>
                                        </tr>
                                        <tr>
                                            <th style={styling.childTH}>Parental waiver: </th>
                                            <td>{c.parentalWaiver ? 'True' : 'False'} </td>
                                        </tr>
                                        <tr>
                                            <th style={styling.childTH}>Parental email opt-in: </th>
                                            <td>{c.parentalEmailOptIn ? 'True' : 'False'} </td>
                                        </tr>
                                        <tr>
                                            <th style={styling.childTH}>Bus waiver: </th>
                                            <td>{c.busWaiver ? 'True' : 'False'} </td>
                                        </tr>
                                        <tr>
                                            <th style={styling.childTH}>Haircut waiver: </th>
                                            <td>{c.haircutWaiver ? 'True' : 'False'} </td>
                                        </tr>
                                        <tr>
                                            <th style={styling.childTH}>Currently checked in: </th>
                                            <td>{c.checkedIn ? 'True' : 'False'} </td>
                                        </tr>
                                        <tr>
                                            <th style={styling.childTH}>Orange shirt status: </th>
                                            <td>{c.orangeShirt ? (c.orangeShirt == 1 ? 'Completed' : 'Relinquished') : 'Pending'}</td>
                                        </tr>
                                        <tr>
                                            <th style={styling.childTH}>Suspension start: </th>
                                            <td>{c.isSuspended ? (new Date(c.suspendedStart)).toDateString() : 'N/A'}</td>
                                        </tr>
                                        <tr>
                                            <th style={styling.childTH}>Suspension end: </th>
                                            <td>{c.isSuspended ? (new Date(c.suspendedEnd)).toDateString() : 'N/A'}</td>
                                        </tr>
                                    </tbody>
                                </table>

                                <EditDetailsButton onButtonClick={this.setEdit} value={c.id} />
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

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    setEdit = (id) => {
        this.setState({
            edit: true,
            editId: id
        })
    }

    render() {
        if (!this.state.loggedin) {
            return <Redirect to={{
                pathname: '/login',
            }} />
        }
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>

                <h1 style={styling.head}>View/Edit Children</h1>

                <p style={styling.center}>Please be patient, this page may take a moment to load.</p>

                <div style={styling.filterdiv}>
                    <h3>Filter roster: </h3>
                    <Form>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Search by Name: </FormLabel>
                            <FormControl type="text" placeholder="Name" value={this.state.name} style={{display:'inline'}} onChange={this.handleNameChange} />
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Gender: </FormLabel>
                            <Form.Control as="select" style={{ display: 'inline'}} value={this.state.gender} onChange={this.handleGenderChange}>
                                <option value={''}>All</option>
                                <option value={'Male'}>Male</option>
                                <option value={'Female'}>Female</option>
                                <option value={'Other'}>Other</option>
                            </Form.Control>
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Grade: </FormLabel>
                            <Form.Control as="select" style={{ display: 'inline'}} value={this.state.grade} onChange={this.handleGradeChange}>
                                <option value={-1}>All</option>
                                <option value={0}>N/A</option>
                                <option value={1}>1</option>
                                <option value={2}>2</option>
                                <option value={3}>3</option>
                                <option value={4}>4</option>
                                <option value={5}>5</option>
                                <option value={6}>6</option>
                                <option value={7}>7</option>
                                <option value={8}>8</option>
                                <option value={9}>9</option>
                                <option value={10}>10</option>
                                <option value={11}>11</option>
                                <option value={12}>12</option>
                            </Form.Control>
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Search&nbsp;by&nbsp;Age: </FormLabel>
                            <FormControl type="number" placeholder="Age" value={this.state.age} style={{ display: 'inline'}} onChange={this.handleAgeChange} />
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Parental&nbsp;waiver: </FormLabel>
                            <Form.Control as="select" style={{ display: 'inline'}} value={this.state.parentalWaiver} onChange={this.handleParentalWaiverChange}>
                                <option value={0}>All</option>
                                <option value={1}>Received</option>
                                <option value={2}>Not received</option>
                            </Form.Control>
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Bus&nbsp;waiver: </FormLabel>
                            <Form.Control as="select" style={{ display: 'inline' }} value={this.state.busWaiver} onChange={this.handleBusWaiverChange}>
                                <option value={0}>All</option>
                                <option value={1}>Received</option>
                                <option value={2}>Not received</option>
                            </Form.Control>
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Haircut&nbsp;waiver: </FormLabel>
                            <Form.Control as="select" style={{ display: 'inline' }} value={this.state.haircutWaiver} onChange={this.handleHaircutWaiverChange}>
                                <option value={0}>All</option>
                                <option value={1}>Received</option>
                                <option value={2}>Not received</option>
                            </Form.Control>
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Parental&nbsp;email&nbsp;opt-in: </FormLabel>
                            <Form.Control as="select" style={{ display: 'inline' }} value={this.state.parentalEmailOptIn} onChange={this.handleParentalEmailOptInChange}>
                                <option value={0}>All</option>
                                <option value={1}>Received</option>
                                <option value={2}>Not received</option>
                            </Form.Control>
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Currently&nbsp;checked&nbsp;in: </FormLabel>
                            <Form.Control as="select" style={{ display: 'inline' }} value={this.state.checkedIn} onChange={this.handleCheckedInChange}>
                                <option value={0}>All</option>
                                <option value={1}>True</option>
                                <option value={2}>False</option>
                            </Form.Control>
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Orange&nbsp;shirt&nbsp;status: </FormLabel>
                            <Form.Control as="select" style={{ display: 'inline' }} value={this.state.orangeShirt} onChange={this.handleOrangeShirtChange}>
                                <option value={-1}>All</option>
                                <option value={0}>Pending</option>
                                <option value={1}>Completed</option>
                                <option value={2}>Relinquished</option>
                            </Form.Control>
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel>Bus: </FormLabel>
                            <Form.Control as="select" value={this.state.busId} onChange={this.handleBusIdChange}>
                                <option value={0}>All</option>
                                {this.renderBuses()}
                            </Form.Control>
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel>Class: </FormLabel>
                            <Form.Control as="select" value={this.state.classId} onChange={this.handleClassIdChange}>
                                <option value={0}>All</option>
                                {this.renderClasses()}
                            </Form.Control>
                        </FormGroup>
                        <Button variant="primary" size="lg" onClick={this.onFilter} style={{margin: '5px'}}>
                            Filter
                        </Button>
                        <Button variant="danger" size="lg" onClick={this.onClearFilter}>
                            Clear Filters
                        </Button>
                    </Form>
                </div>

                <div style={styling.deckDiv}>
                    {this.renderRoster()}
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
    center: {
        textAlign: "center"
    },
    outderdiv: {
        padding: '20px 20px',
        marginLeft: '75px'
    },
    filterdiv: {
        padding: '20px 20px',
        marginLeft: '7%',
    },
    formgroupdiv: {
        display: 'inline-block',
        marginRight: '5px',
        paddingTop: '2px'
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
        marginLeft: '7%'
    },
    ann: {
        marginTop: '15px',
        marginRight: '15px',
        marginBottom: '15px'
    },
    right: {
        float: 'right'
    },
    childTable: {
        tableLayout: 'fixed',
        width: '100%',
        marginBottom:'10px'
    },
    childTH: {
        textAlign: 'right'
    },
    image: {
        maxWidth: '300px',
        maxHeight: '300px',
        height: 'auto',
    },
    imgContainer: {
        textAlign: 'center',
        minHeight: '300px',
        marginBottom: '10px',
    }
}