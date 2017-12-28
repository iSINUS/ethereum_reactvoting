pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/lifecycle/Destructible.sol';
import './LibLinkedList.sol';

contract Questionary is Destructible {
	mapping (bytes32 => mapping (bytes32 => uint)) public votes;

	using LinkedList for LinkedList.LL;
	LinkedList.LL internal questions;
	mapping (bytes32 => LinkedList.LL) internal answers;

	function Questionary() public {
	}

	function AddQuestion(bytes32 _question, bytes32[] _answers) onlyOwner public {
		if (questions.getNode(_question)!=true) {
        	questions.push(_question, true);
		}
		
		for (uint i = 0; i< _answers.length; i++) {
			if (answers[_question].getNode(_answers[i])!=true) {
				answers[_question].push(_answers[i], true);
				votes[_question][_answers[i]] = 0;
			}
		}
	}

	function getQuestion(bytes32 _question) public view returns (bytes32) {
		return questions.step(_question, true);
	}

	function getQuestionsCount() public view returns (uint) {
		return questions.sizeOf();
	}

	function getAnswer(bytes32 _question, bytes32 _answer) public view returns (bytes32) {
		return answers[_question].step(_answer, true);
	}

	function getAnswersCount(bytes32 _question) public view returns (uint) {
		return answers[_question].sizeOf();
	}

	function vote(bytes32 _question, bytes32 _answer) public {
		votes[_question][_answer] += 1;
	}
}