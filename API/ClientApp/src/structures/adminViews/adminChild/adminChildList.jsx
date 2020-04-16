﻿import React, { Component } from 'react'
import { Button, Card } from 'react-bootstrap/'
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
        };

        this.getChildren()
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
                console.log(data.fullRoster)

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

    // Sets variable to false when ready to leave page
    componentWillUnmount = () => {
        this.mounted = false
    }

    // Will set a variable to true when component is fully mounted
    componentDidMount = () => {
        this.mounted = true
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