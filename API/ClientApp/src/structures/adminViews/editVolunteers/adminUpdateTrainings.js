import React, { Component } from 'react'
import { Button, Card } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import './cards.css'

export class AdminUpdateTrainings extends Component {
    constructor(props) {
        super(props)
        this.state = {
            redirect: false,
            jwt: props.location.state.jwt,
            id: props.location.state.id,
            trainings: [{}],
            retrieved: false,
            retrievedv: false,
            completeResult: false,
            incompleteResult: false,
            result: '',
            volunteerTrainings: [{}]

        }
        console.log(this.state.vTraining)
        this.getAllTrainings()
        this.getVolunteerTrainings()
    }

    // Sets variable to false when ready to leave page
    componentWillUnmount = () => {
        this.mounted = false
    }
  
    // Will set a variable to true when component is fully mounted
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
            return <Redirect to={{
                pathname: '/admin-volunteer-list',
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin
                }
            }}/>
        }
    }

    getVolunteerTrainings = () => {
        try {
            fetch('api/volunteer-info?id=' + this.state.id, {
                // method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                }
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('get volunteer successful')
                    this.setState({
                        retrievedv: true
                    })
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('get volunteer failed')
                    this.setState({
                        retrievedv: false
                    })
                    return res.text()
                }
            })
            .then((data) => {
                if(this.state.retrievedv) {
                    let res = JSON.parse(data)
                    res = res.volunteer.trainings
                    if(this.mounted === true){
                        this.setState({
                            volunteerTrainings: res
                        })
                    }
                    console.log(this.state.volunteerTrainings)
                }
            })
        }
        catch(e) {
            console.log(e)
        }
    }

    getAllTrainings = () => {
        try {
            fetch('api/volunteer-trainings', {
                // method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                }
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('job retrieval successful')
                    this.setState({
                        retrieved: true
                    })
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('job retrieval failed')
                    this.setState({
                        retrieved: false
                    })
                    return res.text()
                }
            })
            .then((data) => {
                if(this.state.retrieved) {
                    let res = JSON.parse(data)
                    res = res.trainings
                    if(this.mounted === true){
                        this.setState({
                            trainings: res
                        })
                    }
                    console.log(this.state.trainings)
                }
            })
        }
        catch(e) {
            console.log(e)
        }
    }

    trainingComplete = (ep) => {
        console.log(ep)
        try {
            fetch('api/volunteer-training-complete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                },
                body: JSON.stringify({
                    'volunteerId': Number.parseInt(this.state.id),
                    'trainingId': Number.parseInt(ep)
                })
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('mark training complete successful')
                    this.setState({
                        completeResult: true,
                        result: 'This training has been updated'
                    })
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('mark training complete failed')
                    this.setState({
                        completeResult: false,
                        result: 'This training has not been updated'
                    })
                    return res.text()
                }
            })
            .then(() => {
                if(this.state.completeResult) {
                    window.location.reload(false) 
                }
            })
            
        }
        catch(e) {
            console.log(e)
        }
    }

    trainingIncomplete = (ep) => {
        console.log(ep)
        try {
            fetch('api/volunteer-training-incomplete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                },
                body: JSON.stringify({
                    'volunteerId': Number.parseInt(this.state.id),
                    'trainingId': Number.parseInt(ep)
                })
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('mark training incomplete successful')
                    this.setState({
                        incompleteResult: true,
                        result: 'This training has been updated'
                    })
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('mark training incomplete failed')
                    this.setState({
                        incompleteResult: false,
                        result: 'This training has not been updated'
                    })
                    return res.text()
                }
            })
            .then(() => {
                if(this.state.incompleteResult) {
                    window.location.reload(false) 
                }
            })
            
        }
        catch(e) {
            console.log(e)
        }
    }

    renderTrainings = () => {
        if(this.state.trainings != null){
            const p = this.state.trainings.map((v, index) => {
                // var status = 'Incomplete'
                // console.log(v.name)
                // if(this.state.volunteerTrainings != undefined) {
                    
                //     if(this.state.volunteerTrainings.filter(e => e.name === v.name)){
                //         status = 'Complete'
                //     }
                //     else {
                //         status = 'Incomplete'
                //     }
                // }
                return (
                    <div key={index}>
                        <Card style={{width: '25rem'}}>
                            <Card.Header as='h5'>
                                {v.name}
                            </Card.Header>
                            <Card.Body>
                                {/* <Card.Title>
                                    Information
                                </Card.Title> */}
                                {/* <Card.Text>
                                    Current Status: {status}
                                </Card.Text> */}
                                <Button variant="primary" onClick={() => {this.trainingComplete(v.id)}}>
                                    Complete
                                </Button>
                                <Button variant="primary" style={{marginLeft: '60px'}} onClick={() => {this.trainingIncomplete(v.id)}}>
                                    Incomplete
                                </Button>
                                {/* <p style={this.state.completeResult ? { color: 'green' } : { color: 'red' }}>{this.state.result}</p> */}
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

    render() {
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Volunteer List
                </Button>
                <h1 style={styling.head}>Manage Volunteer Trainings</h1>

                <div style={styling.deckDiv}>
                    {this.renderTrainings()}
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
        marginLeft:'7%'
    },
    ann: {
        marginTop: '15px',
        marginRight: '15px',
        marginBottom: '15px'
    }
}