# TODO this utils needs to be debugged to be used in the notebook
import random
class Warden(object):
    '''
    Class to initialize a Warden object. A Warden is characterised by having:
    * A list of prisioners -> list_of_prisioners
    * A list of the prisioners that have already entered the room -> track_of_prisioners
    * The possibility to select one prisioner at random -> chose_one_prisioner()
    '''
    
    def __init__(self, list_of_prisioners):
        self.list_of_prisioners = list_of_prisioners
        self.track_of_prisioners = []
        
    def chose_one_prisioner(self):
        '''
        Method to select one prisioner at random.
        input: self
        returns: prisioner
        '''
        selected =  random.choice(self.list_of_prisioners)
        if selected not in self.track_of_prisioners:
            self.track_of_prisioners.append(selected)
        return selected
    
#######################    
class StandardPrisioner(object):
    '''
    Class to initialize a StandardPrisioner object. A StandardPriosioner is characterised by:
    * keeping track of having turned the light on or not -> has_turned_ligt_on
    * have the ability to turn the light on -> action_on_light() 
    * answer the warden
    '''
    def __init__(self, has_turned_ligt_on=False):
        self.has_turned_ligt_on = has_turned_ligt_on
    
    def action_on_light(self, switch_state):
        '''
        Method to turn the light on
        inputs: self, switch_state (str: 'on'/'off') 
        '''
        if switch_state== 'on':
            return switch_state
        elif self.has_turned_ligt_on==False:
            self.has_turned_ligt_on = True # turn the ligh on
            return 'on'
        else:
            return switch_state
    def answers_to_warden(self):
        '''
        Method to answer the Warden question
        '''
        return False
        
########################        
class CaptainPrisioner(StandardPrisioner):
    '''
    Class to initialize a CaptainPrisioner object. A CaptainPrisioner is characterised by:
    * keeping count of the times he/she has turned the light off -> count
    * have the ability to turn the light off -> action_on_light() 
    * answer the warden

    '''
    def __init__(self, count=1):
        self.count = count
        
    def action_on_light(self, switch_state):
        if switch_state=='on':
            self.count += 1
        return 'off'
    
    def answers_to_warden(self):
        return True if (self.count == num_of_prisioners) else False