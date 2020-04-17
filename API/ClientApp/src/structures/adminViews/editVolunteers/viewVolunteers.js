import React, { Component } from 'react'
import { Button, Card, Form, FormControl, Spinner } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import './cards.css'

export class ViewVolunteers extends Component {
    constructor(props) {
        super(props)
        this.state = {
            jwt: props.location.state.jwt,
            loggedin: props.location.state.loggedin,
            fullVolunteerList: [],
            volunteerList: [],
            fullTrainings: [],
            redirect: false,
            redirectId: false,
            edit: false,
            volunteer: [],
            redirectTraining: false,
            id: '',
            // Search Criteria
            name: '',
            language: '',
            affiliation: '',
            referral: '',
            orientation: 0,
            newsletter: 0,
            contactWhenShort: 0,
            blueShirt: 0,
            nameTag: 0,
            personalInterviewCompleted: 0,
            backgroundCheck: 0,
            canEditInventory: 0,
            trainings: []

        }
        console.log(this.state.jwt)
        this.updateSearchText = this.updateSearchText.bind(this)
        this.getTrainings()
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
                    fullVolunteerList: res,
                    volunteerList: res
                })
            }
        })
        .catch((err) => {
            console.log(err)
        })
    }

    getTrainings = () => {
        fetch('/api/volunteer-trainings' , {
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
            res = res.trainings
            if(this.mounted === true){
                this.setState({
                    fullTrainings: res,
                    trainings: res
                })
            }
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

    filter = (fullVolunteerList) => {
        let volunteerList = [...fullVolunteerList];

        if (this.state.name) {
            volunteerList = volunteerList.filter(c =>
                c.firstName.toLowerCase().indexOf(this.state.name.toLowerCase()) != -1
                || c.lastName.toLowerCase().indexOf(this.state.name.toLowerCase()) != -1
                || c.preferredName.toLowerCase().indexOf(this.state.name.toLowerCase()) != -1
            );
        }

        if (this.state.orientation) {
            volunteerList = volunteerList.filter(c => this.state.orientation == 1 ? c.orientation : !c.orientation);
        }
        
        if (this.state.newsletter) {
            volunteerList = volunteerList.filter(c => this.state.newsletter == 1 ? c.newsletter : !c.newsletter);
        }
        
        if (this.state.contactWhenShort) {
            volunteerList = volunteerList.filter(c => this.state.contactWhenShort == 1 ? c.contactWhenShort : !c.contactWhenShort);
        }

        if (this.state.blueShirt) {
            volunteerList = volunteerList.filter(c => this.state.blueShirt == 1 ? c.blueShirt : !c.blueShirt);
        }

        if (this.state.nameTag) {
            volunteerList = volunteerList.filter(c => this.state.nameTag == 1 ? c.nameTag : !c.nameTag);
        }

        if (this.state.personalInterviewCompleted) {
            volunteerList = volunteerList.filter(c => this.state.personalInterviewCompleted == 1 ? c.personalInterviewCompleted : !c.personalInterviewCompleted);
        }

        if (this.state.backgroundCheck) {
            volunteerList = volunteerList.filter(c => this.state.backgroundCheck == 1 ? c.backgroundCheck : !c.backgroundCheck);
        }

        if (this.state.canEditInventory) {
            volunteerList = volunteerList.filter(c => this.state.canEditInventory == 1 ? c.canEditInventory : !c.canEditInventory);
        }

        return volunteerList;
    }

    onFilter = () => {
        if (!this.state.fullVolunteerList || this.state.fullVolunteerList.length == 0)
            return;

        this.setState({
            volunteerList: this.filter(this.state.fullVolunteerList)
        })
    }

    onClearFilter = () => {
        this.setState({
            name: '',
            language: '',
            affiliation: '',
            referral: '',
            orientation: 0,
            newsletter: 0,
            contactWhenShort: 0,
            blueShirt: 0,
            nameTag: 0,
            personalInterviewCompleted: 0,
            backgroundCheck: 0,
            canEditInventory: 0,
            trainings: []
        })

        if (this.state.fullVolunteerList && this.state.fullVolunteerList.length > 0) {
            this.setState({
                roster: this.state.fullVolunteerList
            })
        }
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
        if(this.state.volunteerList != null){
            const p = this.state.volunteerList.map((v, index) => {
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
                return (<div key={index}>
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
            })
            return (
                <div className="row">
                    {p}
                </div>
            )
        }
    }


    updateSearchText = (e) => {
        this.setState({
            nameSearch: e.target.value
        })
        console.log(this.state.nameSearch)
    }
    

    handleNameChange = (e) => {
        this.setState({
            name: e.target.value
        })
    }

    handleLanguageChange = (e) => {
        this.setState({
            language: e.target.value
        })
    }

    handleAffiliationChange = (e) => {
        this.setState({
            affiliation: e.target.value
        })
    }

    handleReferralChange = (e) => {
        this.setState({
            referral: e.target.value
        })
    }

    handleOrientationChange = (e) => {
        this.setState({
            orientation: e.target.value
        })
    }

    handleNewsletterChange = (e) => {
        this.setState({
            newsletter: e.target.value
        })
    }

    handleContactChange = (e) => {
        this.setState({
            contactWhenShort: e.target.value
        })
    }

    handleBlueShirtChange = (e) => {
        this.setState({
            blueShirt: e.target.value
        })
    }

    handleNameTagChange = (e) => {
        this.setState({
            nameTag: e.target.value
        })
    }

    handleInterviewChange = (e) => {
        this.setState({
            personalInterviewCompleted: e.target.value
        })
    }

    handleBackgroundChange = (e) => {
        this.setState({
            backgroundCheck: e.target.value
        })
    }

    handleInventoryChange = (e) => {
        this.setState({
            canEditInventory: e.target.value
        })
    }

    handleTrainingChange = (e) => {
        this.setState({
            trainings: e.target.value
        })
    }

    renderTrainings = () => {
        if (this.state.fullTrainings != null) {
            // const p = this.state.fullTrainings.map((t, index) => {
            //     return <Form.Check key={index} inline value={t.id} label={t.name} type={"checkbox"} />
            // })
            // return p;
            // <FormGroup style={styling.formgroupdiv}>
            //     <FormLabel>Trainings: </FormLabel>
            //     <Form.Control as="select" multiple value={options} onChange={this.handleTrainingChange}>
            //         {options.map(options => (
            //         <option key={option.name} value={option.value}>
            //             {option.name}
            //         </option>
            //         ))}
            //     </Form.Control>
            // </FormGroup>
            const p = this.state.fullTrainings.map((t, index) => {
                return <Form.Check key={index} inline value={t.id} label={t.name} type={"checkbox"} />
            })
            return p;
        }
    }

    renderLoading = () => {
        return (
            <div style={styling.center}>
                <Spinner animation="border" />
            </div>
        )
    }

    render() {

        return (this.state.volunteerList != null && this.state.volunteerList.length > 0)
            ? (<div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>

                {this.editVolunteers()}
                <Button variant="primary" size="lg" style={styling.ann} onClick={this.setEdit} className="float-right">
                    Search Volunteer ID
                </Button>

                <h1 style={styling.head}>Volunteer List</h1>

                <div style={styling.filterdiv}>
                    <h3>Filter volunteers: </h3>
                    <Form>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Search by Name: </FormLabel>
                            <FormControl type="text" placeholder="Name" value={this.state.name} style={{display:'inline'}} onChange={this.handleNameChange} />
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Search by Language: </FormLabel>
                            <FormControl type="text" placeholder="Name" value={this.state.language} style={{display:'inline'}} onChange={this.handleLanguageChange} />
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Search by Affiliation: </FormLabel>
                            <FormControl type="text" placeholder="Name" value={this.state.affiliation} style={{display:'inline'}} onChange={this.handleAffiliationChange} />
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Search by Referral: </FormLabel>
                            <FormControl type="text" placeholder="Name" value={this.state.referral} style={{display:'inline'}} onChange={this.handleReferralChange} />
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Orientation: </FormLabel>
                            <Form.Control as="select" style={{ display: 'inline'}} value={this.state.orientation} onChange={this.handleOrientationChange}>
                                <option value={0}>All</option>
                                <option value={1}>Completed</option>
                                <option value={2}>Not Completed</option>
                            </Form.Control>
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Newsletter: </FormLabel>
                            <Form.Control as="select" style={{ display: 'inline' }} value={this.state.newsletter} onChange={this.handleNewsletterChange}>
                                <option value={0}>All</option>
                                <option value={1}>Acceptable</option>
                                <option value={2}>Not Acceptable</option>
                            </Form.Control>
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Contact When Short: </FormLabel>
                            <Form.Control as="select" style={{ display: 'inline' }} value={this.state.contactWhenShort} onChange={this.handleContactChange}>
                                <option value={0}>All</option>
                                <option value={1}>Acceptable</option>
                                <option value={2}>Not Acceptable</option>
                            </Form.Control>
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Blue Shirt: </FormLabel>
                            <Form.Control as="select" style={{ display: 'inline' }} value={this.state.blueShirt} onChange={this.handleBlueShirtChange}>
                                <option value={0}>All</option>
                                <option value={1}>True</option>
                                <option value={2}>False</option>
                            </Form.Control>
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Personal Interview: </FormLabel>
                            <Form.Control as="select" style={{ display: 'inline' }} value={this.state.personalInterviewCompleted} onChange={this.handleInterviewChange}>
                                <option value={0}>All</option>
                                <option value={1}>Completed</option>
                                <option value={2}>Not Completed</option>
                            </Form.Control>
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Background Check: </FormLabel>
                            <Form.Control as="select" style={{ display: 'inline' }} value={this.state.backgroundCheck} onChange={this.handleBackgroundChange}>
                                <option value={0}>All</option>
                                <option value={1}>Completed</option>
                                <option value={2}>Not Completed</option>
                            </Form.Control>
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel style={{ display: 'inline' }}>Can Modify Inventory: </FormLabel>
                            <Form.Control as="select" style={{ display: 'inline' }} value={this.state.canEditInventory} onChange={this.handleInventoryChange}>
                                <option value={0}>All</option>
                                <option value={1}>True</option>
                                <option value={2}>False</option>
                            </Form.Control>
                        </FormGroup>
                        <FormGroup style={styling.formgroupdiv}>
                            <FormLabel>Trainings: </FormLabel>
                            <Form.Control as="select" value={this.state.trainings} onChange={this.handleTrainingChange}>
                                {this.renderTrainings()}
                            </Form.Control>
                        </FormGroup>
                        <Button variant="primary" size="lg" onClick={this.onFilter} style={{margin: '5px'}}>
                            Filter
                        </Button>
                        <Button variant="danger" size="lg" onClick={this.onClearFilter}>
                            Clear Filters
                        </Button>
                    </Form>
                </div>

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

                <div  style={styling.center}>
                    <p>
                        Please wait while we load the information!
                    </p>
                    {this.renderLoading()}
                </div>
                
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