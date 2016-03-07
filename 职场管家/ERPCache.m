//
//  ERPCache.m
//  职场管家
//
//  Created by Jackie Liu on 16/1/19.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "ERPCache.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "Login.h"
#import <BmobSDK/Bmob.h>
#import "CommonFunction.h"
#import "Config.h"

#define FMDBQuickCheck(SomeBool, Title, Db) {\
if (!(SomeBool)) { \
NSLog(@"Failure on line %d, %@ error(%d): %@", __LINE__, Title, [Db lastErrorCode], [Db lastErrorMessage]);\
}}


NSString * dbFilePath(NSString * filename) {
    NSArray * documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString * documentDirectory = [documentPaths objectAtIndex:0];
    NSString * pathName = [documentDirectory stringByAppendingPathComponent:@"cache"];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:pathName])
        [fileManager createDirectoryAtPath:pathName withIntermediateDirectories:YES attributes:nil error:nil];
    
    pathName = [pathName stringByAppendingPathComponent:filename];
    
    return pathName;
};

NSData * encodePwd(NSString * pwd) {
    
    NSData * data = [pwd dataUsingEncoding:NSUTF8StringEncoding];
    
    return data;
};

NSString * decodePwd(NSData * data) {
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
};


@implementation ERPCache

static FMDatabase * __db;
static NSString *__currentPath;
static NSString *__currentPlistPath;
static NSString *__offlineMsgPlistPath;
static NSMutableDictionary * __contactsOnlineState;

+ (void)initialize {
    
    NSLog(@"Is SQLite compiled with it's thread safe options turned on? %@!", [FMDatabase isSQLiteThreadSafe] ? @"Yes" : @"No");
    
}

#pragma mark -重置当前用户本地数据库链接
+ (void)resetCurrentLogin {
    
    [__db close];
    __db = nil;
    
    if (__currentPath) {
        __currentPath = nil;
    }
    
    if (__currentPlistPath) {
        __currentPlistPath = nil;
    }
    
    if (__offlineMsgPlistPath) {
        __offlineMsgPlistPath = nil;
    }
}


#pragma mark -打开当前用户本地数据库链接
+ (void)openDBWithObjectId:(NSString *)objectId {
    
    [ERPCache resetCurrentLogin];
    
    if (!objectId)
        return;
    
    NSString * fileName = dbFilePath([NSString stringWithFormat:@"data_%@.sqlite", objectId]);
    
    __currentPath = [fileName copy];
    __db = [FMDatabase databaseWithPath:fileName];
    
    if (![__db open]) {
        NSLog(@"Could not open db:%@", fileName);
        
        return;
    }
    
    [__db setShouldCacheStatements:YES];
    
    // 个人设置
    if (![__db tableExists:str_TableName_Settings]) {
        NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE %@ (objectId TEXT, nickname TEXT,  gender TEXT, avatar BLOB, avatarURL TEXT, position TEXT,email TEXT)", str_TableName_Settings];
        
        BOOL b = [__db executeUpdate:sqlString];
        
        FMDBQuickCheck(b, sqlString, __db);
        
    }
    // 好友列表
    if (![__db tableExists:str_TableName_Contact]) {
        
        NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE %@ (objectId TEXT,username TEXT, nickname TEXT, gender TEXT, avatar BLOB, avatarURL TEXT, position TEXT, email TEXT)", str_TableName_Contact];
        
        BOOL b = [__db executeUpdate:sqlString];
        
        FMDBQuickCheck(b, sqlString, __db);

        
    }

}

+ (void)storePersonalSettings:(Settings *)settings {
    
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return ;
            }
        }
        BmobUser *user = [BmobUser getCurrentUser];
        if (!user) return;
        if (user) {
            settings.objectId = user.objectId;
        }
        if (!settings.objectId) {
            settings.objectId = @"";
        }
        if (!settings.nickname) {
            settings.nickname = @"";
        }

        if (!settings.gender) {
            settings.gender = @"0";
        }
        if (!settings.avatarURL) {
            settings.avatarURL = @"";
        }
        if (!settings.position) {
            settings.position = @"";
        }
        if (!settings.email) {
            settings.email = @"";
        }
        NSData *avatarData = [NSData data];
        if (settings.avatar) {
            avatarData = UIImageJPEGRepresentation(settings.avatar, 1.0);
        }
        BOOL hasRec = NO;
        NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE objectId=?", str_TableName_Settings];
        FMResultSet *rs = [__db executeQuery:sqlString withArgumentsInArray:@[settings.objectId]];
        hasRec = [rs next];
        [rs close];
        if (hasRec) {
            
            sqlString = [NSString stringWithFormat:@"UPDATE %@ SET nickname=?, gender=?, avatar=?, avatarURL=?, position=?, email=? WHERE objectId=?", str_TableName_Settings];
            
            BOOL b = [__db executeUpdate:sqlString withArgumentsInArray:@[settings.nickname, settings.gender, avatarData, settings.avatarURL, settings.position,settings.email,settings.objectId]];
            
            FMDBQuickCheck(b, sqlString, __db);
            
        } else {
            
            sqlString = [NSString stringWithFormat:@"INSERT INTO %@(objectId, nickname, gender, avatar, avatarURL,position,email) values(?, ?, ?, ?, ?, ?, ?)", str_TableName_Settings];
            
            BOOL b = [__db executeUpdate:sqlString withArgumentsInArray:@[settings.objectId, settings.nickname,settings.gender, avatarData, settings.avatarURL,settings.position,settings.email]];
            
            FMDBQuickCheck(b, sqlString, __db);
        }
        
        [NotificationCenter postNotificationName:Notify_Settings_Save object:nil];
    }
}



+ (void)storeContact:(Contact *)contact{
    
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return ;
            }
        }
        if(!contact.objectId){
            contact.objectId = @"";
        }
        if (!contact.username) {
            contact.username = @"";
        }
        if (!contact.nickname) {
            contact.nickname = @"";
        }
        
        if (!contact.gender) {
            contact.gender = @"0";
        }
        if (!contact.avatarURL) {
            contact.avatarURL = @"";
        }
        if (!contact.position) {
            contact.position = @"";
        }
        if (!contact.email) {
            contact.email = @"";
        }
        
        NSData *avatarData = [NSData data];
        if (contact.avatar) {
            avatarData = UIImageJPEGRepresentation(contact.avatar, 1.0);
        }
        BOOL hasRec = NO;
        NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE objectId=? AND username=?", str_TableName_Contact];
        FMResultSet *rs = [__db executeQuery:sqlString withArgumentsInArray:@[contact.objectId,contact.username]];
        hasRec = [rs next];
        [rs close];
        if (hasRec) {
            
            sqlString = [NSString stringWithFormat:@"UPDATE %@ SET nickname=?, gender=?, avatar=?, avatarURL=?, position=?, email=? WHERE objectId=? AND username=?", str_TableName_Contact];
            
            BOOL b = [__db executeUpdate:sqlString withArgumentsInArray:@[contact.nickname, contact.gender, avatarData, contact.avatarURL,contact.position,contact.email,contact.objectId,contact.username]];
            
            FMDBQuickCheck(b, sqlString, __db);
            
            
        } else {
            
            sqlString = [NSString stringWithFormat:@"INSERT INTO %@(objectId, username, nickname, gender, avatar, avatarURL, position, email) values(?, ?, ?, ?, ?, ?, ?, ?)", str_TableName_Contact];
            
            BOOL b = [__db executeUpdate:sqlString withArgumentsInArray:@[contact.objectId, contact.username,contact.nickname,contact.gender, avatarData, contact.avatarURL, contact.position,contact.email]];
            
            FMDBQuickCheck(b, sqlString, __db);
        }
        
//        [NotificationCenter postNotificationName:Notify_Settings_Save object:nil];
    }
}




+ (Settings *)getPersonalSettings {
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return nil;
            }
        }
        
        Settings *settings = [[Settings alloc] init];
        BmobUser *user = [BmobUser getCurrentUser];
        if (user) {
            settings.objectId = user.objectId;
        } else {
            settings.objectId = @"";
        }
        
        NSString *sqlString = [NSString stringWithFormat:@"SELECT objectId, nickname, gender, avatar, avatarURL, position, email FROM %@ WHERE objectId=?", str_TableName_Settings];
        
        FMResultSet *rs = [__db executeQuery:sqlString withArgumentsInArray:@[settings.objectId]];
        while ([rs next]) {
            settings.objectId = [rs stringForColumn:@"objectId"];
            settings.nickname = [rs stringForColumn:@"nickname"];
            settings.gender = [rs stringForColumn:@"gender"];
            NSData *imageData = [rs dataForColumn:@"avatar"];
            if (imageData) {
                settings.avatar = [UIImage imageWithData:imageData];
            }
            settings.avatarURL = [rs stringForColumn:@"avatarURL"];
//            settings.createtime = [rs stringForColumn:@"createtime"];
//            settings.updatetime = [rs stringForColumn:@"updatetime"];
            settings.position = [rs stringForColumn:@"position"];
            settings.email = [rs stringForColumn:@"email"];

        }
        [rs close];
        
        return settings;
    }
}
//返回某个好友的具体信息
+(Contact *)getContact:(NSString *)username{
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return nil ;
            }
        }
        Contact *contact = [[Contact alloc] init];
        NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE username=?", str_TableName_Contact];
        FMResultSet *rs = [__db executeQuery:sqlString withArgumentsInArray:@[username]];
        while ([rs next]) {
            contact.username = [rs stringForColumn:@"username"];
            contact.objectId = [rs stringForColumn:@"objectId"];
            contact.nickname = [rs stringForColumn:@"nickname"];
            contact.gender = [rs stringForColumn:@"gender"];
            contact.position = [rs stringForColumn:@"position"];
            contact.email = [rs stringForColumn:@"email"];
            NSData *imageData = [rs dataForColumn:@"avatar"];
            if (imageData) {
                contact.avatar = [UIImage imageWithData:imageData];
            }
            contact.avatarURL = [rs stringForColumn:@"avatarURL"];
        }
        [rs close];
        
        return contact;
    }

}

//返回好友列表
+(NSArray *)getContact{
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return nil ;
            }
        }
        BmobUser *buser= [BmobUser getCurrentUser];
        NSString *objectId = @"";
        if (buser) {
            objectId = buser.objectId;
        }
        NSMutableArray *array = [NSMutableArray array];
        NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@", str_TableName_Contact];
        
        FMResultSet *rs = [__db executeQuery:sqlString];
        
        while ([rs next]) {
            Contact *contact = [[Contact alloc]init];
            contact.username = [rs stringForColumn:@"username"];
            contact.objectId = objectId;
            contact.nickname = [rs stringForColumn:@"nickname"];
            contact.gender = [rs stringForColumn:@"gender"];
            contact.position = [rs stringForColumn:@"position"];
            contact.email = [rs stringForColumn:@"email"];
            NSData *imageData = [rs dataForColumn:@"avatar"];
            if (imageData) {
                contact.avatar = [UIImage imageWithData:imageData];
            }
            contact.avatarURL = [rs stringForColumn:@"avatarURL"];
            [array addObject:contact];
        }
        [rs close];
        

    return array;
    }
}


+(void)deleteContact:(NSString *)username{
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return ;
            }
        }
        BOOL hasRec = NO;
        NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE username=?", str_TableName_Contact];
        
        FMResultSet *rs = [__db executeQuery:sqlString withArgumentsInArray:@[username]];
        hasRec = [rs next];
        [rs close];
        if (hasRec) {
            
            sqlString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE username=?", str_TableName_Contact];
            
          BOOL b = [__db executeUpdate:sqlString withArgumentsInArray:@[username]];
            
            FMDBQuickCheck(b, sqlString, __db);
            NSLog(@"删除成功！！！！！！！！！！！！！");
            
        }
      


    }

}

@end

