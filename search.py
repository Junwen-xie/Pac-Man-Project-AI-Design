# search.py
# ---------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
# 
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


"""
In search.py, you will implement generic search algorithms which are called by
Pacman agents (in searchAgents.py).
"""

import util

class SearchProblem:
    """
    This class outlines the structure of a search problem, but doesn't implement
    any of the methods (in object-oriented terminology: an abstract class).

    You do not need to change anything in this class, ever.
    """

    def getStartState(self):
        """
        Returns the start state for the search problem.
        """
        util.raiseNotDefined()

    def isGoalState(self, state):
        """
          state: Search state

        Returns True if and only if the state is a valid goal state.
        """
        util.raiseNotDefined()

    def getSuccessors(self, state):
        """
          state: Search state

        For a given state, this should return a list of triples, (successor,
        action, stepCost), where 'successor' is a successor to the current
        state, 'action' is the action required to get there, and 'stepCost' is
        the incremental cost of expanding to that successor.
        """
        util.raiseNotDefined()

    def getCostOfActions(self, actions):
        """
         actions: A list of actions to take

        This method returns the total cost of a particular sequence of actions.
        The sequence must be composed of legal moves.
        """
        util.raiseNotDefined()


def tinyMazeSearch(problem):
    """
    Returns a sequence of moves that solves tinyMaze.  For any other maze, the
    sequence of moves will be incorrect, so only use this for tinyMaze.
    """
    from game import Directions
    s = Directions.SOUTH
    w = Directions.WEST
    return  [s, s, w, s, w, w, s, w]

def depthFirstSearch(problem):
    """
    Search the deepest nodes in the search tree first.

    Your search algorithm needs to return a list of actions that reaches the
    goal. Make sure to implement a graph search algorithm.

    To get started, you might want to try some of these simple commands to
    understand the search problem that is being passed in:

    print "Start:", problem.getStartState()
    print "Is the start a goal?", problem.isGoalState(problem.getStartState())
    print "Start's successors:", problem.getSuccessors(problem.getStartState())
    """
    "*** YOUR CODE HERE ***"
    from game import Directions
    from util import Stack
    #Create a stark_list to call class Stack
    stack_list = Stack()
    #Get the initial point from the START POINT and make it stop
    start = problem.getStartState()
    #This is the move state that help to store information
    move = [start,Directions.STOP,0]
    # Push move in to Stack
    stack_list.push(move)
    # Visited is a list used to remember which node is visited
    visited = []
    # this is the path
    path = []
    #Final route to find the food
    route = []
    #Stack with stack
    stack_list.push(move)
    path.append([start])
# this While loop is running forever until it find the Gettarget
    while True:
      move = stack_list.pop()
      if problem.isGoalState(move[0]):break
      path1 = path.pop()
# Add Visited node when search in Visited LIST
      if move[0] not in visited:
        visited.append(move[0])

# Successor is to return which node next to current state
        successors = problem.getSuccessors(move[0])
        for x in successors:
#Search if node is not visited Else Add it into path route
          if x[0] not in visited:
            stack_list.push(x)
            t = []
            t= path1[:]
            t.append(x)
            path.append(t)

    #print path
    for x in path[-1][1:]:
      route.append(x[1])

    #print route
    return route

    util.raiseNotDefined()


def breadthFirstSearch(problem):
    """Search the shallowest nodes in the search tree first."""
    "*** YOUR CODE HERE ***"
    from game import Directions
    from util import Queue
    # Create a Queue_list to call class Stack
    Queue_list = Queue()
    # Get the initial point from the START POINT and make it stop
    start = problem.getStartState()
    # This is the move state that help to store information
    move = [start, Directions.STOP, 0]
    # Push move in to Stack

    # Visited is a list used to remember which node is visited
    visited = []
    # this is the path
    path = []
    # Final route to find the food
    route = []
    # QUeue with list of move
    Queue_list.push(move)
    path.append([start])
    # this While loop is running forever until it find the Gettarget
    while True:
      move = Queue_list.pop()
     # print "%%%%%%%%%%%",move
      if problem.isGoalState(move[0]): break
      path1 = path.pop(0)
      # Add Visited node when search in Visited LIST
      if move[0] not in visited:
        visited.append(move[0])

        # Successor is to return which node next to current state
        successors = problem.getSuccessors(move[0])
        for x in successors:
          # Search if node is not visited Else Add it into path route
          if x[0] not in visited:
            Queue_list.push(x)
            t = []
            t = path1[:]
            t.append(x)
            path.append(t)

    #print "this is path", path
    for x in path[0][1:]:
      route.append(x[1])

    #print route
    return route
    util.raiseNotDefined()

def uniformCostSearch(problem):
    """Search the node of least total cost first."""
    "*** YOUR CODE HERE ***"

    from game import Directions
    from util import PriorityQueue
    #  Important : This methods is referenced by online source
    #


    #initial the priority_queue
    priority_queue = PriorityQueue()

    #get start state -------named as start
    start = problem.getStartState()

    #push items into priority_queue
    priority_queue.push((start, []), 0)

    visited_list = []

    while not priority_queue.isEmpty():

        node, actions = priority_queue.pop()
        #print "this is NODE++++++++++++", node

        #print  "This is Action", actions


        ###
        ###
        # while find the Goal, return the action list[]
        if problem.isGoalState(node):
            return actions
        # colse all other noded if it has been visited
        if node not in visited_list:
           visited_list.append(node)


        # important : i cant find how to write this thing

           # if find node in next steps whitch is returned form successors
           for x, dir, steps in problem.getSuccessors(node):
            if not x in visited_list:
                # update the new actions into new
                new = actions + [dir]

                #print "This is new =============",new
                #push new
                priority_queue.push((x, new), problem.getCostOfActions(new))


    util.raiseNotDefined()

def nullHeuristic(state, problem=None):
    """
    A heuristic function estimates the cost from the current state to the nearest
    goal in the provided SearchProblem.  This heuristic is trivial.
    """
    return 0

def aStarSearch(problem, heuristic=nullHeuristic):
    """Search the node that has the lowest combined cost and heuristic first."""
    "*** YOUR CODE HERE ***"


    from util import PriorityQueue

    #As a Visited which is used for store the node have visited
    visited_list = []

    #initial the priorityQueue
    aStart_list = PriorityQueue()

    #get satrt point
    start = problem.getStartState()

    #push items into list
    aStart_list.push((start, []), heuristic(start, problem))

    #Same as UCS but return Heru
    while not aStart_list.isEmpty():
        node, actions = aStart_list.pop()
    
        if problem.isGoalState(node):
            return actions

        # colse all other noded if it has been visited
        if node not in visited_list:
          visited_list.append(node)


          for x, dir, cost in problem.getSuccessors(node):
            if not x in visited_list:

                new = actions + [dir]
                #Score is the item with cost and heuristic
                score = problem.getCostOfActions(new) + heuristic(x, problem)
a
                #print "score",score
                aStart_list.push((x, new), score)

    util.raiseNotDefined()


# Abbreviations
bfs = breadthFirstSearch
dfs = depthFirstSearch
astar = aStarSearch
ucs = uniformCostSearch
