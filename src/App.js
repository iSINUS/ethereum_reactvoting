import React, { Component } from 'react'
import QuestionaryContract from '../build/contracts/Questionary.json'
import getWeb3 from './utils/getWeb3'

import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'

class App extends Component {
  

  constructor(props) {
    super(props)

    const contract = require('truffle-contract')

    this.questionary = contract(QuestionaryContract)

    this.state = {
      questions: null,
      web3: null
    }
  }

  componentWillMount() {
    // Get network provider and web3 instance.
    // See utils/getWeb3 for more info.

    getWeb3
    .then(results => {
      this.setState({
        web3: results.web3
      })

      // Instantiate contract once web3 provided.
      this.instantiateContract()
    })
    .catch(() => {
      console.log('Error finding web3.')
    })
  }

  instantiateContract() {
    /*
     * SMART CONTRACT EXAMPLE
     *
     * Normally these functions would be called in the context of a
     * state management library, but for convenience I've placed them here.
     */


    this.questionary.setProvider(this.state.web3.currentProvider)

    var questionaryInstance
    this.state.web3.eth.getAccounts((error, accounts) => {
      this.questionary.deployed().then((instance) => {
        questionaryInstance = instance

        return questionaryInstance.AddQuestion("Question 1", ["Answer 11", "Answer 12", "Answer 13"], {from: accounts[0], gas: 1000000})
      }).then((result) => {

        return questionaryInstance.AddQuestion("Question 2", ["Answer 21", "Answer 22", "Answer 23"], {from: accounts[0], gas: 1000000})
      }).then((result) => {

        return this.readQuestionary()
      }).then((result) => {

      })
    })
  }

  readQuestionary() {
    var questionaryInstance
    this.state.web3.eth.getAccounts((error, accounts) => {
      this.questionary.deployed().then((instance) => {
        questionaryInstance = instance

        return questionaryInstance.getQuestions.call();
      }).then((result) => {
        for (var i = 0, leni = result.length; i < leni; i++) {          
          result[i] = this.state.web3.toAscii(result[i]).replace(/\u0000/g, '') 
         /*  var answers = questionaryInstance.getAnswers.call(result[i]).then((result) => {
            for (var j = 0, lenj = result.length; j < lenj; j++) {
              result[j] = this.state.web3.toAscii(result[j]).replace(/\u0000/g, '')
            }
            return result
          })
          console.log(answers.then((tmp) => {return JSON.stringify(tmp)}))
          console.log(JSON.stringify(result[i],answers)) */
        }
        return result
      }).then((result) => {

        return this.setState({ questions: result })
      }).then((result) => {

      })
    })
  }

  render() {
    return (
      <div className="App">
        <nav className="navbar pure-menu pure-menu-horizontal">
            <a href="#" className="pure-menu-heading pure-menu-link">Truffle Box</a>
        </nav>

        <main className="container">
          <div className="pure-g">
            <div className="pure-u-1-1">
              <h1>Good to Go!</h1>
              <p>Your Truffle Box is installed and ready.</p>
              <h2>Smart Contract Example</h2>
              <p>The stored questions are: {this.state.questions}</p>
            </div>
          </div>
        </main>
      </div>
    );
  }
}

export default App
