import React, { useRef, Component } from 'react'
import { Button, Card, Dropdown, DropdownButton, Spinner } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import './cards.css'
import { EditDetailsButton } from '../customButtons'
import QRCode from 'qrcode.react'
import ReactToPrint from 'react-to-print'


class RosterComponent extends React.Component {
    render() {
        if (this.props.roster != null) {
            const p = this.props.roster.map((c, index) => {
                return (
                    (c.bus.id == this.props.bus.id && !c.isSuspended)
                    ? <div key={index}>
                        <Card style={{ width: '25rem' }}>
                            <Card.Header as='h5'>
                                {(c.preferredName || c.firstName) + ' ' + (c.preferredName ? '(' + c.firstName + ')' : '') + ' ' + c.lastName} <span style={{ fontWeight: 'bold', color: 'red', float: 'right' }}>{c.isSuspended ? 'SUSPENDED' : ''}</span>
                            </Card.Header>
                            <Card.Body>
                                <div style={styling.imgContainer}>
                                    <QRCode value={("operationportal.com!" + c.id)} />
                                </div>
                            </Card.Body>
                        </Card>
                    </div>
                    : <div key={index}></div>
                )
            })
            return (
                <div style={styling.deckDiv} className="row">
                    {p}
                </div>
            )
        }
    }
}

export class UserQRList extends Component {
    constructor(props) {
        super(props) 
        this.state = {
            redirect: false,
            jwt: props.location.state.jwt,
            role: props.location.state.role,
            successBus: false,
            resultBus: '',
            successRoster: false,
            resultRoster: '',
            buses: [],
            roster: [],
            bus: null,
            loading: false,
            myRef: React.createRef(),
        }
        this.getBus()
    }

    renderPrintAndRoster = () => {
        if(this.state.bus != null) {
            return (
                <div>
                    <ReactToPrint
                        trigger={() => <Button variant="primary" size="lg" style={styling.butt}>Print QR Sheet</Button>}
                        content={() => this.state.myRef.current}
                    />
    
                    <RosterComponent roster={this.state.roster} bus={this.state.bus} ref={this.state.myRef} />
                </div>
            );
        }
        else if(this.state.bus === null) {
            return (
                <div>
                    <center>
                        <p>Please select a bus.</p>
                    </center>
                </div>
            )
        }
        
    };

    // Sets variable to false when ready to leave page
    componentWillUnmount = () => {
        this.mounted = false
        this.loading = false
    }

    // Will set a variable to true when component is fully mounted
    componentDidMount = () => {
        this.mounted = true
        this.loading = true
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

    renderLoading = () => {
        const sty = { position: "fixed", top: "50%", left: "50%"};
        return (
            <div>
                <Spinner style={sty} animation="border" />
            </div>
                
        )
    }

    renderBusDropdown = () => {
        if (this.state.buses != null) {
            const p = this.state.buses.map((b, index) => {
                return (
                    <div key={index}>
                        <Dropdown.Item as="button"  onClick={() => this.updateSelectedBus(b)}>{b.name}</Dropdown.Item>
                    </div>
                )
                
            })
            return (
                <div>
                    <span>
                        <DropdownButton id="dropdown-basic-button" title={this.state.bus == null ? "Select Bus" : "Current Bus: " + this.state.bus.name} size="lg" style={styling.butt}>
                            {p}
                        </DropdownButton>
                    </span>
                </div>
            )
        }
    }

    updateSelectedBus = (e) => {
        this.setState({
            bus: e,
            loading: true
        })
        console.log(e)
        this.getChildren(e)
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
                    res = res.buses
                    this.setState({
                        buses: res
                    })
                    console.log(this.state.buses)
                }
            })
        }
        catch(e) {
            console.log(e)
        }
    }

    getChildren = (id) => {
        if(id != null) {
            this.setState({
                loading: true
            })
            var busid = id.id
            fetch('/api/roster?busId=' + busid, {
                // method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                }
            })
            .then((res) => {
                console.log(res.status)
                if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                    console.log('got roster')
                    this.setState({
                        successRoster: true
                    })
                    return res.text()
                }
                else if ((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true) {
                    console.log('did not get roster')
                    this.setState({
                        successRoster: false
                    })
                    return res.text()
                }
            })
            .then((data) => {
                var res = JSON.parse(data)
                console.log(res)
                if(this.state.successRoster) {
                    res = res.busRoster
                    this.setState({
                        roster: res,
                        loading: false
                    })
                    console.log(this.state.roster)
                }
            })
            .catch((err) => {
                console.log(err)
            })
        }
        
    }



    render() {
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>
                {this.renderBusDropdown()}
                <h1 style={styling.head}>QR List</h1>
                {this.state.loading ? 
                    this.renderLoading() 
                    :
                    this.renderPrintAndRoster()
                }
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
    butt: {
        marginTop: '15px',
        marginLeft: '15px',
        marginBottom: '15px'
    },
    deckDiv: {
        justifyContent: 'center',
        alignContent: 'center',
        marginTop: '50px',
    },
    right: {
        float: 'right'
    },
    image: {
        maxWidth: '300px',
        maxHeight: '300px',
        height: 'auto',
    },
    imgContainer: {
        textAlign: 'center',
        minHeight: '200px',
    }
}