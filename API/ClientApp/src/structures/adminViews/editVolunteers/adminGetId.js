import React, { Component } from 'react'
import { Redirect } from 'react-router-dom'
import { Form, FormControl, FormGroup, FormLabel, Button, Col, Row } from 'react-bootstrap/'

export class AdminGetId extends Component {
    constructor(props){
        super(props)
        this.state = {
            redirect: false,
            jwt: props.location.state.jwt,
            loggedin: props.location.state.loggedin,
            id: '',
            redirectId: false,
            regexp : /^[0-9\b]+$/,
            volunteer: []
        }
        this.getId = this.getId.bind(this)
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
        else if(this.state.redirectId) {
            return (
                <Redirect to={{
                    pathname: '/admin-volunteer-edit',
                    state: {
                        jwt: this.state.jwt,
                        loggedin: this.state.loggedin,
                        volunteer: this.state.volunteer
                    }
                }}/>
            )
        }
    }

    getId = (e) => {
        let idd = e.target.value
        if(idd === '' || this.state.regexp.test(idd)) {
            this.setState({
                id: idd,
            })
        }
        console.log(this.state.id)
    }

    getSpecificVolunteer = () => {

        // https://www.operation-portal.com/api/volunteer-info?id=' + gi
        // http://localhost:5000/api/volunteer-info?id=' + gi
        var gi = Number.parseInt(this.state.id, 10)

        try{
            fetch('https://www.operation-portal.com/api/volunteer-info?id=' + gi , {
            // method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                }
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('Retrieval successful')
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('Retrieval failed')
                    return
                }
            })
            .then((data) => {
                let res = JSON.parse(data)
                res = res.volunteer
                if(this.mounted === true){
                    this.setState({
                        volunteer: res
                    })
                }
                console.log(this.state.volunteer)
            })
            .then(() => {
                this.setState({
                    redirectId: true
                })
            })
        }
        catch(e) {
            console.log("didnt post")
        }
    }

    render() {
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to View Volunteers
                </Button>

                <h1 style={styling.head}>Enter User ID</h1>
                <div style={styling.outderdiv}>
                    <Form>
                        <FormGroup>
                            <FormLabel>
                                ID Number
                            </FormLabel>
                            <FormControl type="text" placeholder="Enter Unique ID Number" value={this.state.id} onChange={this.getId} />
                        </FormGroup>
                        <center>
                            <Button variant="primary" size="lg" style={styling.butt} onClick={this.getSpecificVolunteer}>
                                Submit
                            </Button>
                        </center>
                        
                    </Form>
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
    }
}