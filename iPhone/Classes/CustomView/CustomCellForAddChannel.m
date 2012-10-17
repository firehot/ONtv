
#import "CustomCellForAddChannel.h"
#import "UIUtils.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CustomCellForAddChannel()

- (void)createSelectedCellBackGround;

@end

@implementation CustomCellForAddChannel

@synthesize channelLabel;
@synthesize langCode = _langCode;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,50)];
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 84, 40)];
       // backgroundView.image = [UIImage imageNamed:@"imageBackground.png"];
        
        [self createSelectedCellBackGround];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigChannelLogo"]];
		logoImageView = imageView;
		logoImageView.frame = CGRectMake(16, 11, 50, 20);
        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
		[backgroundView addSubview:logoImageView];
        backgroundView.backgroundColor=[UIUtils colorFromHexColor:@"F5F5F5"];
        [self.contentView addSubview:backgroundView];
	}
	
    return self;
}

- (void)prepareForReuse
{
    [logoImageView cancelCurrentImageLoad];
    [super prepareForReuse];
}



- (void)createSelectedCellBackGround {
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,50)];
    [self.selectedBackgroundView setBackgroundColor:[UIColor whiteColor]];
}




- (void)addChannelNameLabel {
    
	UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 12, 200, 20)];
	nameLabel.textColor = [UIColor grayColor];
	nameLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	nameLabel.textColor = [UIColor blackColor];//[UIUtils colorFromHexColor:@"486b9a"];
	nameLabel.backgroundColor = [UIColor clearColor];
	self.channelLabel = nameLabel;
	[self.contentView addSubview:self.channelLabel];

}

- (void)addLangNameLabel {
    
	UILabel *langLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 25, 150, 20)];
	langLabel.textColor = [UIColor grayColor];
	langLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	langLabel.textColor = [UIUtils colorFromHexColor:GRAY];
	langLabel.backgroundColor = [UIColor clearColor];
	self.langCode = langLabel;
	[self.contentView addSubview:self.langCode];
    
}

- (void)setPhoto:(NSString*)channelPhoto {
	[logoImageView setImageWithURL:[NSURL URLWithString:channelPhoto] placeholderImage:[UIImage imageNamed:@"bigChannelLogo"]];
}


@end
