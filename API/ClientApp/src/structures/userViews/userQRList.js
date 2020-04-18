import React, { useRef, Component } from 'react'
import { Button, Card, Dropdown, DropdownButton, Spinner } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import './cards.css'
import { EditDetailsButton } from '../customButtons'
import QRCode from 'qrcode.react'
import ReactToPrint from 'react-to-print'

export class UserQRList extends Component {
    constructor(props) {
        super(props) 
        this.state = {
            redirect: false,
            jwt: props.location.state.jwt,
            role: props.location.state.role,
            successBus: false,
            resultBus: '',
            buses: []
        }
        this.getBus()
        this.getChildren()
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
                    pathname: '/dashboard',
                    state: {
                        jwt: this.state.jwt,
                        role: this.state.role
                    }
                }}/>
            )
        }
    }

    getBus = () => {
        try{
            fetch('api/auth/user', {
                // method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                }
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('get user successful')
                    this.setState({
                        successBus: true
                    })
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('get user successful')
                    this.setState({
                        successBus: false
                    })
                    return res.text()
                }
            })
            .then((data) => {
                
                if(this.state.successBus) {
                    var res = JSON.parse(data)
                    console.log(res)
                }
                else if(this.state.successBus === false) {
                    console.log(data)
                }
            })
        }
        catch(e) {
            console.log(e)
        }
    }

    getChildren = () => {
        fetch('/api/roster', {
            // method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.state.jwt}`
            }
        })
        .then((res) => {
            console.log(res.status)
            if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                return res.text()
            }
            else if ((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true) {
                return res.text()
            }
        })
        .then((data) => {
            var res = JSON.parse(data)
            console.log(res)
            if (this.mounted === true) {
                // console.log(res.fullRoster)

                // this.setState({
                //     fullRoster: r.fullRoster,
                //     roster: data.fullRoster,
                // })
            }
        })
        .catch((err) => {
            console.log(err)
        })
    }



    render() {
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>
            </div>
        )
    }
}

const styling = {
    head: {
        textAlign: "center"
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px',
        marginBottom: '15px'
    },
    header: {
        textAlign: 'center',
        justifyContent: 'center',
        marginTop: '40px'
    },
    form: {
        padding: '20px 20px'
    }
}