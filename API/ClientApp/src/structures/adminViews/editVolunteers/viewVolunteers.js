import React, { Component } from 'react'
import { Button, Card } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import './cards.css'

export class ViewVolunteers extends Component {
    constructor(props) {
        super(props)
        this.state = {
            jwt: props.location.state.jwt,
            loggedin: props.location.state.loggedin,
            volunteers_list: [],
            redirect: false,
            redirectId: false,
            edit: false,
            volunteer: [],
            redirectTraining: false,
            searchText: React.createRef(),
            id: ''
        }
        console.log(this.state.jwt)
        this.getVolunteers()
    }

    renderRedirect = () => {
        if(this.state.redirect) {
            return <Redirect to={{
                pathname: '/admin-dashboard',
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin
                }
            }}/>
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
        else if(this.state.redirectTraining) {
            return (
                <Redirect to={{
                    pathname: '/admin-update-trainings',
                    state: {
                        jwt: this.state.jwt,
                        id: this.state.id
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


    getVolunteers = () => {

        let live = 'https://www.operation-portal.com/api/volunteer-list'
        let local = 'http://localhost:5000/api/volunteer-list'
        fetch('/api/volunteer-list' , {
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
            res = res.volunteers
            if(this.mounted === true){
                this.setState({
                    volunteers_list: res
                })
            }
            console.log(this.state.volunteers_list)
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

    editVolunteers = () => {
        if(this.state.edit) {
            return (
                <Redirect to={{
                    pathname: '/admin-get-id',
                    state: {
                        jwt: this.state.jwt,
                        loggedin: this.state.loggedin
                    }
                }}/>
            )
        }
    }

    setEdit = () => {
        this.setState({
            edit: true
        })
    }

    updateTrainings = (ep, t) => {
        this.setState({
            redirectTraining: true,
            id: ep
        })
    }

    profileClicked = (ep) => {
        console.log(ep)
        let live = 'https://www.operation-portal.com/api/volunteer-info?id=' + ep
        let local = 'http://localhost:5000/api/volunteer-info?id=' + ep

        try{
            fetch('/api/volunteer-info?id=' + ep, {
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

    renderVolunteers = () => {
        if(this.state.volunteers_list != null){
            const p = this.state.volunteers_list.map((v, index) => {
                if(v.trainings != undefined) {
                    var train = v.trainings.map((details) => {
                        return (
                            details.name + ' | '
                        )
                    })
                }
                if(v.languages != undefined) {
                    var language = v.languages.map((details) => {
                        return (
                            details + ' | ' 
                        )
                    })
                }
                return ( (this.state.searchText != "" && this.state.searchText.length > 0)
                ? ( (( v.firstName.contains(this.state.searchText.current.text) || v.lastName.contains(this.state.searchText.current.text) ))  
                    ? (<div key={index}>
                        <Card style={{width: '25rem'}}>
                            <Card.Header as='h5'>
                                {v.firstName + " " +  v.lastName}
                            </Card.Header>
                            <Card.Body>
                                <div style={styling.imgContainer}>
                                    <img style={styling.image} src={v.picture ? `data:image/jpeg;base64,${v.picture}` : 'https://i.imgur.com/tdi3NGag.png'} />
                                </div>
                                <Card.Title>
                                    Information
                                </Card.Title>
                                <Card.Text>
                                    ID: {v.id}<br></br>
                                    Preferred Name: {v.preferredName}<br></br>
                                    Email: {v.email}<br></br>
                                    Phone: {v.phone}<br></br>
                                    Birthday: {v.birthday}<br></br>
                                    <br></br>
                                    Role: {v.role}<br></br>
                                    Weeks Attended: {v.weeksAttended}<br></br>
                                    <br></br>
                                    Trainings:<br></br>
                                    {train}
                                    <br></br>
                                    <br></br>
                                    Languages:<br></br>
                                    {language}
                                    <br></br>
                                    <br></br>
                                    Orientation: {v.orientation ? 'Yes' : 'No'}<br></br>
                                    Blue Shirt: {v.blueShirt  ? 'Yes' : 'No'}<br></br>
                                    Name Tag: {v.nameTag  ? 'Yes' : 'No'}<br></br>
                                    Personal Interview: {v.personalInterviewCompleted  ? 'Yes' : 'No'}<br></br>
                                    Background Check: {v.backgroundCheck  ? 'Yes' : 'No'}<br></br>
                                    Year Started: {v.yearStarted}<br></br>
                                    Can Edit Inventory: {v.canEditInventory  ? 'Yes' : 'No'}<br></br>
                                </Card.Text>
                                <Button variant="primary" onClick={() => {this.profileClicked(v.id)}}>
                                    Edit Volunteer Profiles
                                </Button>
                                <Button variant="primary" style={{marginLeft: '15px'}} onClick={() => {this.updateTrainings(v.id, v.trainings)}}>
                                    Update Trainings
                                </Button>
                            </Card.Body>
                        </Card>
                    </div>)
                    : (<div></div>)
                )
                : (<div key={index}>
                    <Card style={{width: '25rem'}}>
                        <Card.Header as='h5'>
                            {v.firstName + " " +  v.lastName}
                        </Card.Header>
                        <Card.Body>
                            <div style={styling.imgContainer}>
                                <img style={styling.image} src={v.picture ? `data:image/jpeg;base64,${v.picture}` : 'https://i.imgur.com/tdi3NGag.png'} />
                            </div>
                            <Card.Title>
                                Information
                            </Card.Title>
                            <Card.Text>
                                ID: {v.id}<br></br>
                                Preferred Name: {v.preferredName}<br></br>
                                Email: {v.email}<br></br>
                                Phone: {v.phone}<br></br>
                                Birthday: {v.birthday}<br></br>
                                <br></br>
                                Role: {v.role}<br></br>
                                Weeks Attended: {v.weeksAttended}<br></br>
                                <br></br>
                                Trainings:<br></br>
                                {train}
                                <br></br>
                                <br></br>
                                Languages:<br></br>
                                {language}
                                <br></br>
                                <br></br>
                                Orientation: {v.orientation ? 'Yes' : 'No'}<br></br>
                                Blue Shirt: {v.blueShirt  ? 'Yes' : 'No'}<br></br>
                                Name Tag: {v.nameTag  ? 'Yes' : 'No'}<br></br>
                                Personal Interview: {v.personalInterviewCompleted  ? 'Yes' : 'No'}<br></br>
                                Background Check: {v.backgroundCheck  ? 'Yes' : 'No'}<br></br>
                                Year Started: {v.yearStarted}<br></br>
                                Can Edit Inventory: {v.canEditInventory  ? 'Yes' : 'No'}<br></br>
                            </Card.Text>
                            <Button variant="primary" onClick={() => {this.profileClicked(v.id)}}>
                                Edit Volunteer Profiles
                            </Button>
                            <Button variant="primary" style={{marginLeft: '15px'}} onClick={() => {this.updateTrainings(v.id, v.trainings)}}>
                                Update Trainings
                            </Button>
                        </Card.Body>
                    </Card>
                </div>)
            ) 
            })
            return (
                <div className="row">
                    {p}
                </div>
            )
        }
    }


    updateSearchText = (e) => {
        console.log(e);
    }

    render() {

        return (this.state.volunteers_list != null && this.state.volunteers_list.length > 0)
            ? (<div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>

                {this.editVolunteers()}
                <Form inline>
                    <FormControl type="text" placeholder="Search" className="mr-sm-2" ref={this.state.searchText} />
                    <Button variant="outline-success" onClick={() => this.updateSearchText(this.state.searchText.current.text)}>Search Volunteers</Button>
                </Form>
                <Button variant="primary" size="lg" style={styling.ann} onClick={this.setEdit} className="float-right">
                    Search Volunteer ID
                </Button>

                <h1 style={styling.head}>Volunteer List</h1>

                <div style={styling.deckDiv}>
                    {this.renderVolunteers()}
                </div>
                
            </div>) 
            : (<div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>

                <h1 style={styling.head}>Volunteer List</h1>

                <p style={styling.center}>
                    Please wait while we load the information!
                    {this.renderLoading()}
                </p>
            </div>)
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
    },
    center: {
        textAlign: "center"
    },
}