# on command prompt: pip install tweepy==3.3.0
import pip
package_name='tweepy' 
pip.main(['install',package_name])
import tweepy
from tweepy import OAuthHandler
 
consumer_key = 'bjNHw9ZB2W7TL5GZpAXBiEYGA'
consumer_secret = 'rkzmLcl4l75tQjQcuNiqFUNDWfw9R4mgqemvXTu7LAADcYR4Lg'
access_token = 'J5KSqQKb2OISYdIBWI1XM3hOFeentxLiThA1IfL1'
access_secret = '5Y5TRhFfrLWjNDCWv3b4XeWhiQixzvqT79LnvvWGVHUyL'
 
auth = OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_secret)
 
api = tweepy.API(auth)
