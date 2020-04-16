import React, { Component } from 'react';
import { Button, Card } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'


export class AdminJobRoster extends Component {
    constructor(props) {
        super(props)
        this.state = {
            redirect: false,
            jwt: props.location.state.jwt,
            clicked: props.location.state.clicked,
            retrieved: false,
            jobs: [{}]
        }

        this.getJobs()
    }

    componentWillUnmount = () => {
        this.mounted = false
    }
    
    componentDidMount = () => {
        this.mounted = true
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    renderRedirect = () => {
        if(this.state.redirect) {
            return (
                <Redirect to={{
                    pathname: '/admin-calendar',
                    state: {
                        jwt: this.state.jwt,
                        clicked: this.state.clicked
                    }
                }}/>
            )
        }
    }

    renderJobs = () => {
        if(this.state.retrieved){
            let eve = this.state.jobs.map((v, index) => {
                // let a = e.date
                // let year = a.substring(0, 4)
                // let month = a.substring(5, 7)
                // let day = a.substring(8, 10)
                // let nue = month + '/' + day + '/' + year
                return (
                    <div key={index}>
                        <Card style={{width: '25rem'}}>
                            <Card.Header as='h5'>
                                {v.name}
                            </Card.Header>
                            <Card.Body>
                                <Card.Title>
                                    Information
                                </Card.Title>
                                <Card.Text>
                                    ID: {v.id}<br></br>
                                    Current Amount: {v.currentNumber}<br></br>
                                    Minimum: {v.min}<br></br>
                                    Maximum: {v.max}<br></br>
                                    <br></br>
                                    Volunteers Signed Up:<br></br>
                                    {v.volunteers.map((details) => {
                                        var a = details.preferredName + ' ' + details.lastName + ' | '
                                        return (
                                            a
                                        )
                                    })}
                                </Card.Text>
                            </Card.Body>
                        </Card>
                    </div>
                )
            })
            return (
                <div className="row">
                    {eve}
                </div>
            )

        }
    }

    getJobs = () => {
        var a = this.state.clicked
        var date = a.month + '/' + a.day + '/' + a.year
        try {
            fetch('api/calendar/details?date=' + date , {
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
                    console.log(date + ' details successful')
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log(date + ' details unsuccessful')
                    return res.text()
                }
            })
            .then((data) => {
                var res = JSON.parse(data)
                if(res.jobs != null) {
                    res = res.jobs
                    this.setState({
                        retrieved: true,
                        jobs: res
                    })
                    console.log(this.state.jobs)
                }
            })
        }
        catch(e) {
            console.log(e)
        }
    }

    render() {
        var a = this.state.clicked
        var date = a.month + '/' + a.day + '/' + a.year
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Calendar
                </Button>
                <h1 style={styling.head}>Job Roster for {date}</h1>
                <div style={styling.deckDiv}>
                    {this.renderJobs()}
                </div>
            </div>
        )
    }
}

const styling = {
    head: {
        marginBottom: '15px',
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
    // table: {
    //     height: '400px',
    //     width: '1000px'
    // },
    deckDiv: {
        justifyContent: 'center',
        alignContent: 'center',
        outline: 'none',
        border: 'none',
        overflowWrap: 'normal',
        marginLeft:'7%'
    },
    // ann: {
    //     marginTop: '15px',
    //     marginRight: '15px',
    //     marginBottom: '15px'
    // }
}