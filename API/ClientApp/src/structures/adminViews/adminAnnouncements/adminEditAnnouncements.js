import React, { Component } from 'react';
import { Button, Form, InputGroup } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

export class AdminEditAnnouncements extends Component {
    constructor(props) {
        super(props)
        this.state = {
            redirect: false,
            jwt: props.location.state.jwt,
            id: props.location.state.id,
            title: props.location.state.title,
            message: props.location.state.message,
            titleupdate: '',
            messageupdate: '',
            startdate: '',
            enddate: '',
            start: props.location.state.start,
            end: props.location.state.end
        }

    }

    componentWillUnmount = () => {
        this.mounted = false
    }
    
    componentDidMount = () => {
        this.mounted = true
    }
    
    renderRedirect = () => {
        if(this.state.redirect){
            return <Redirect to={{
                pathname: '/admin-announcements',
                state: {
                    jwt: this.state.jwt
                }
            }}/>
        }
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
    
    editAnnouncements = () => {
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
            fetch('api/announcement-edit' , {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`,
                    'Accept': 'application/json'
                    
                },
                body: JSON.stringify({
                    'id': this.state.id,
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
        }
        catch(e) {
            console.log(e)
        }
    }



    renderAnnouncements = () => {
        
        return (
            <div style={styling.add}>
                <h1 style={styling.head}>Edit Announcements</h1>
                <Form>
                    <Form.Group>
                        <Form.Label>Title</Form.Label>
                        <Form.Control type="text" placeholder="Title of Announcement" onChange={this.handleTitleChange}/>
                        <Form.Text>
                            Original: {this.state.title}
                        </Form.Text>
                    </Form.Group>

                    <Form.Group>
                        <Form.Label>Message</Form.Label>
                        <Form.Control as="textarea" type="text" placeholder="Message for Announcement" onChange={this.handleMessageChange}/>
                        <Form.Text>
                            Original: {this.state.message}
                        </Form.Text>
                    </Form.Group>

                    <Form.Group>
                        <Form.Label>Start Date</Form.Label>
                        <Form.Control type="date" onChange={this.handleStartDateChange}/>
                        <Form.Text>
                        Original: {this.state.start}
                        </Form.Text>
                    </Form.Group>

                    <Form.Group>
                        <Form.Label>End Date</Form.Label>
                        <Form.Control type="date" onChange={this.handleEndDateChange}/>
                        <Form.Text>
                        Original: {this.state.end}
                        </Form.Text>
                    </Form.Group>
                    
                    <Button variant="link" variant="primary" size="lg" onClick={this.editAnnouncements}>
                        Update Announcement
                    </Button>
                </Form>
            </div>
        )
    }

    
    render () {

        return(
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Announcements
                </Button>
                <div style={styling.outerdiv}>
                    {this.renderAnnouncements()}
                </div>
                
                
            </div> 
        )
    }
}

const styling = {
    butt: {
        marginTop: '15px',
        marginLeft: '15px'
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
        marginBottom: '75px'
    },
    add: {
        marginBottom: '50px'
    }
}


