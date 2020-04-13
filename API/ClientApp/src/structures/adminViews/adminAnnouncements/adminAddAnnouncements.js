import React, { Component } from 'react'
import { Button, Form } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

export class AdminAddAnnouncements extends Component {
    constructor(props){
        super(props)
        this.state = {
            jwt: props.location.state.jwt,
            titleupdate: '',
            messageupdate: '',
            startdate: '',
            enddate: ''
        }
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

    handleTitleChange = (e) => {
        this.setState({
            titleupdate: e.target.value
        })
        console.log(this.state.titleupdate)
    }

    handleMessageChange = (e) => {
        this.setState({
            messageupdate: e.target.value
        })
        console.log(this.state.messageupdate)
    }  

    handleStartDateChange = (e) => {
        this.setState({
            startdate: e.target.value
        })
        console.log(this.state.startdate)
    }

    handleEndDateChange = (e) => {
        this.setState({
            enddate: e.target.value
        })
        console.log(this.state.enddate)
    }

    renderRedirect = () => {
        if(this.state.redirect){
            return (
                <Redirect to={{
                    pathname: '/admin-announcements',
                    state: {
                        jwt: this.state.jwt
                    }
                }}/>
            )
        }
    }

    addAnnouncement = () => {
        let a = this.state.startdate
        let year = a.substring(0, 4)
        let month = a.substring(5, 7)
        let day = a.substring(8,10)
        let reta = month + '/' + day + '/' + year
        console.log(reta)

        let b = this.state.enddate
        let year1 = b.substring(0, 4)
        let month1 = b.substring(5, 7)
        let day1 = b.substring(8,10)
        let retb = month1 + '/' + day1 + '/' + year1
        console.log(retb)
        try {
            fetch('api/announcement-creation' , {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`,
                    'Accept': 'application/json'
                    
                },
                body: JSON.stringify({
                    'title': this.state.titleupdate,
                    'message': this.state.messageupdate,
                    'startDate': reta,
                    'endDate': retb
                })
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('announcement changed')
                    this.setState({
                        redirect: true
                    })
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('announcement not changed')
                    return res.text()
                }
            })
            .then((data) => {
                console.log(data)
            })
        }
        catch(e) {
            console.log(e)
        }
    }

    render() {
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Announcements
                </Button>
                <h1 style={styling.head}>Add Announcements</h1>
                <div style={styling.outderdiv}>
                    <Form>
                        <Form.Group>
                            <Form.Label>Title</Form.Label>
                            <Form.Control type="text" placeholder="Title of Announcement" onChange={this.handleTitleChange}/>
                            <Form.Text>
                                Please enter a title for this announcement.
                            </Form.Text>
                        </Form.Group>

                        <Form.Group>
                            <Form.Label>Message</Form.Label>
                            <Form.Control as="textarea" type="text" placeholder="Message for Announcement" onChange={this.handleMessageChange}/>
                            <Form.Text>
                                Please enter a message for this announcement.
                            </Form.Text>
                        </Form.Group>

                        <Form.Group>
                            <Form.Label>Start Date</Form.Label>
                            <Form.Control type="date" onChange={this.handleStartDateChange}/>
                            <Form.Text>
                                Please enter a start date for this announcement.
                            </Form.Text>
                        </Form.Group>

                        <Form.Group>
                            <Form.Label>End Date</Form.Label>
                            <Form.Control type="date" onChange={this.handleEndDateChange}/>
                            <Form.Text>
                                Please enter a end date for this announcement.
                            </Form.Text>
                        </Form.Group>
                        
                        <Button variant="link" variant="primary" size="lg" onClick={this.addAnnouncement}>
                            Add Announcement
                        </Button>
                    </Form>
                </div>
            </div>
        )
    }
}

const styling = {
    head: {
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
    ann: {
        marginTop: '15px',
        marginRight: '15px',
        marginBottom: '15px'
    },
    show: {
        marginBottom: '20px',
        float: 'right'
    }
}