import React, { Component } from 'react'
import { Button, Card } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import '../cards.css'
import { CheckInButton, CancelCheckInButton } from '../../customButtons'

export class AdminDriverCheckIn extends Component {
    constructor(props) {
        super(props)

        if (props.location.state) {
            this.state = {
                jwt: props.location.state.jwt,
                loggedin: props.location.state.loggedin,
                redirect: false,
                result: '',
                success: false,
                getSuccess: false,
                date: this.getSaturdayDate(),
                drivers: []
            };
        }
        else {
            this.state = {
                loggedin: false,
            }
        }

        this.getBusDrivers();
    }

    componentDidMount() {
        this.mounted = true
    }

    getSaturdayDate() {
        let d = new Date();

        d.setDate(d.getDate() + (6 - d.getDay()));

        return d;
    }

    getBusDrivers(date) {
        fetch('/api/bus-drivers?date=' + this.state.date.toISOString(), {
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
                    drivers: data.drivers
                })
            }
        })
    }

    onCheckIn = (id) => {
        fetch('/api/check-in/bus-driver', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.state.jwt}`
            },
            body: JSON.stringify({ Id: id, Date: this.state.date })
        })
        .then((res) => {
            if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                this.setState({
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
            if (this.state.success) {
                this.state.drivers.find(d => d.id == id).checkedIn = true;
                this.forceUpdate();
            }
            else {
                alert("An error occurred: " + data.error);
            }
        })
    }

    onCancel = (id) => {
        fetch('/api/check-in/bus-driver-cancel', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.state.jwt}`
            },
            body: JSON.stringify({ Id: id, Date: this.state.date })
        })
        .then((res) => {
            if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                this.setState({
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
            if (this.state.success) {
                this.state.drivers.find(d => d.id == id).checkedIn = false;
                this.forceUpdate();
            }
            else {
                alert("An error occurred: " + data.error);
            }
        })
    }

    renderDrivers = () => {
        console.log(this.state.drivers);
        if (this.state.drivers != null) {
            const p = this.state.drivers.map((d, index) => {
                return (
                    <tr key={index}>
                        <td style={styling.driverTd}>{d.preferredName} {d.lastName}</td>
                        <td style={styling.driverTd}>{d.checkedIn ? 'Checked In' : 'Not Checked In'}</td>
                        <td style={styling.driverTd}>{d.checkedIn ? <CancelCheckInButton onButtonClick={this.onCancel} value={d.id} /> : <CheckInButton onButtonClick={this.onCheckIn} value={d.id} />}</td>
                    </tr>
                )
            });
            console.log(p);
            return p;
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
    }

    setRedirect = () => {
        this.setState({
            redirect: true
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

                <div style={styling.head}>
                    <h1>Check in bus drivers: {this.state.date.toDateString()}</h1>
                </div>

                <div style={styling.outderdiv}>
                    <table style={styling.driverTable}>
                        <tbody>
                            {this.renderDrivers()}
                        </tbody>
                    </table>
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
    driverTable: {
        tableLayout: 'fixed',
        width: '100%',
    },
    driverTd: {
        textAlign: 'center',
    }
}