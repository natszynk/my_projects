
import argparse
import logging
import sys

# funckja licząca w zalenoci od parametrów 
def calc(params):
    if params.operation == 'add':
        return params.num1 + params.num2
    elif params.operation == 'sub':
        return params.num1 - params.num2
    elif params.operation == 'mul':
        return params.num1 * params.num2
    elif params.operation == 'div':
        return params.num1 / params.num2
    else: 
        return None
    

# główna funkcja 
def main(params):
    
    log = logging.getLogger('test_script')
    result = calc(params)
    log.debug('Operation {0} for numbers: {1}, {2}'.format(params.operation,params.num1,params.num2))
    if result:
        log.info('Result: {0}'.format(result))
    else:
        log.error('Wrong operation!')
    

if __name__ == "__main__":
    ## parsowanie argmentów z konsoli 
    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    
    parser.add_argument('--num1', type=int, default=1,
                        help="First number")
    
    parser.add_argument('--num2', type=int, default=1,
                        help="Second number")
    
    parser.add_argument('--operation', type=str, default='add',
                        help="Operation type. Possible choices: 'add', 'sub', 'mul' ,'div'  ")
    
    parser.add_argument('--debug', action='store_const', const=True, default=False,
                        help='Set debug logging level, otherwise info level is set.') 
    
    parser.add_argument('--to_file', action='store_const', const=True, default=False,
                        help='possible logging to file') 
    

    params = parser.parse_args()
    # konfiguracja loggera
    logger = logging.getLogger('test_script')
    logger.setLevel(logging.DEBUG)
    if params.to_file:
        ch = logging.StreamHandler(sys.stdout)  
    else:
        ch = logging.StreamHandler()
        
    ch.setLevel(logging.DEBUG if params.debug else logging.INFO)
    ch.setFormatter(logging.Formatter(fmt='%(asctime)s [%(name)s:%(levelname)s]: %(message)s',
                                      datefmt="%H:%M:%S"))
    logger.addHandler(ch)
    # wywolanie funckji main
    main(params)
