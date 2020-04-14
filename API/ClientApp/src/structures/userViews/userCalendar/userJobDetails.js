import React, { Component } from 'react'
import { Redirect } from 'react-router-dom'
import { Button, Form } from 'react-bootstrap/'

export class UserJobDetails extends Component {
    constructor(props) {
        super(props)
        this.state =  {
            redirect: false,
            jwt: props.location.state.jwt,
            id: props.location.state.id,
            date: props.location.state.date,
            jobs: [{}],
            default_job: -1,
            enabled: false,
            job_result: null,
            removal: null,
            role: props.location.state.role
        }
        this.getAllJobs()
        this.checkJobsEnabled()
    }

    componentWillUnmount = () => {
        this.mounted = false
    }
    
    componentDidMount = () => {
        this.mounted = true
    }

    renderRedirect = () => {
        if(this.state.redirect) {
            return (
                <Redirect to={{
                    pathname: '/user-calendar',
                    state: {
                        jwt: this.state.jwt,
                        role: this.state.role
                    }
                }}/>
            )
        }
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    getAllJobs = () => {
        try{
            fetch('api/volunteer-jobs?date=' + this.state.date , {
                // method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                  }
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('got jobs')
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('did not get jobs')
                    return
                }
            })
            .then((data) => {
                var res = JSON.parse(data)
                res = res.jobs
                this.setState({
                    jobs: res
                })
                console.log(this.state.jobs)

            })
        }
        catch(e) {
            console.log(e)
        }
    }

    choseJob = (e) => {
        this.setState({
            default_job: Number.parseInt(e.target.value)
        })
        console.log(this.state.default_job)
    }

    checkJobsEnabled = () => {
        try {
            fetch('api/volunteer-jobs-enabled' , {
                // method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                },
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('check successful')
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('check unsuccessful')
                    return
                }
            })
            .then((data) => {
                var res = JSON.parse(data)
                res = res.enabled
                this.setState({
                    enabled: res
                })
                console.log(this.state.enabled)
            })
        }
        catch(e) {
            console.log(e)
        }
    }

    submitJobs = () => {
        var full = {}
        for(var i = 0; i < this.state.jobs.length; i++) {
            if(this.state.jobs[i].id === this.state.default_job) {
                full = this.state.jobs[i]
            }
        }
        var c = (full.currentNumber < full.max)
        console.log(c)
        if(this.state.enabled && c){
            try {
                fetch('api/volunteer-jobs-assignment' , {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${this.state.jwt}`
                    },
                    body: JSON.stringify(
                        {
                            volunteerId: this.state.id,
                            jobId: this.state.default_job,
                            date: this.state.date
                        }
                    )
                })
                .then((res) => {
                    console.log(res.status)
                    if((res.status === 200 || res.status === 201) && this.mounted === true){
                        console.log('added job for user')
                        this.setState({
                            redirect: true
                        })
                        return res.text()
                    }
                    else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                        console.log('did not add job for user')
                        return
                    }
                })
            }
            catch(e) {
                console.log(e)
            }
        }
        
    }

    removeJobs = () => {
        console.log(this.state.id)
        console.log(this.state.default_job)
        console.log(this.state.date)
        try {
            fetch('api/volunteer-jobs-removal' , {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                },
                body: JSON.stringify(
                    {
                        volunteerId: this.state.id,
                        jobId: this.state.default_job,
                        date: this.state.date
                    }
                )
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('removed user for job')
                    this.setState({
                        redirect: true
                    })
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('did not remove user for job')
                    
                    return
                }
            })
        }
        catch(e) {
            console.log(e)
        }
    }

    renderJobs = () => {
        let j = this.state.jobs.map((details, index) => {
            return (
                <option key={index} value={details.id}>{details.name}</option>
            )
        })
        return (
            <div style={styling.eves}>
                <Form>
                    <Form.Group>
                        <Form.Label><b>Date</b></Form.Label>
                        <Form.Control plaintext readOnly defaultValue={this.state.date}/>
                    </Form.Group>
                    <Form.Group>
                        <Form.Label><b>Choose a Job</b></Form.Label>
                        <Form.Control as="select" value={this.state.default_job} onChange={this.choseJob}>
                            <option>none</option>
                            {j}
                        </Form.Control> 
                        <Form.Text>
                            <b>Please only choose 1 job to signup for.</b>
                        </Form.Text>
                    </Form.Group>
                    
                    <Button variant="link" variant="primary" size="lg" onClick={this.submitJobs} style={styling.sub}>
                        Sign Up
                    </Button>
                    <Button variant="link" variant="primary" size="lg" onClick={this.removeJobs} style={styling.sub}>
                        Cancel
                    </Button>
                </Form>
            </div>
        )
    }

    render() {
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Calendar
                </Button>
                <h1 style={styling.head}>Job signup/cancel for {this.state.date}</h1>
                <div style={styling.outerdiv}>
                    <h3>Notice</h3>
                    <p>
                        If signup or cancellation is successful, you will be taken back to the calendar. Please
                        remember to only signup for 1 job. 
                    </p>
                    {this.renderJobs()}
                </div>
                
            </div>
        )
    }
}


const styling = {
    cal: {
        height: '550px',
        padding: '20px 20px'
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px'
    },
    add: {
        marginBottom: '50px'
    },
    head: {
        marginBottom: "15px",
        textAlign: "center"
    },
    outerdiv: {
        padding: '20px 20px',
        marginLeft: '75px',
        marginRight: '75px'
    },
    eves: {
        marginBottom: '20px'
    },
    sub: {
        marginRight: '100px'
    }
}