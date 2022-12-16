clc;
close all;
clear;
cover_image = imread('yellowlily.jpg');
cover_image=imresize(cover_image, [512 512]);
message =input ('Enter your message: ' , 's');
text_read_ascii = uint8(message);
binaryString = transpose(de2bi(text_read_ascii,8));
size_binaryString = size(binaryString);
final_message = reshape(binaryString,1,size_binaryString(1)*size_binaryString(2));
final_message(length(final_message)+1:length(final_message)+30) = [0];

i1 = 1;
stego_image=cover_image;


while(i1 <= 512)
    for j1 = 1:3:512
        pixel_count = 0;
        for i = i1:i1+2
            for j = j1:j1+2
                pixel_count = pixel_count+1;
                if(pixel_count==5)
                    A1=i;
                    A2=j;
                    old=stego_image(i,j);
                    
                    binary_form=de2bi(old,8);
                    if(length(final_message)==0)
                        break
                    end
                    
                    binary_form(3:-1:1)=final_message(1:3);

                    final_message(1:3)=[];
                    new=bi2de(binary_form);
                    devi=old-new;
                    if(devi>8 && (new+16)>=0 && (new+16)<=255)
                        stego_image(i,j)=new+16;
                        
                      
                    elseif(devi<(-8) && (new-16)>=0 && (new-16)<=255)
                        stego_image(i,j)=new-16;
                        
                       
                    else
                        stego_image(i,j)=new;
                        
                    end
                
                end
            end
            if(length(final_message)==0)
                break
            end
        end
        inner_loop=0;
        for x1=i1:i1+2
            for x2=j1:j1+2
                inner_loop=inner_loop+1;

                if(inner_loop~=5)
                    
                    if(stego_image(x1,x2)>stego_image(A1,A2))
                        diff=stego_image(x1,x2)-stego_image(A1,A2);
                    elseif(stego_image(x1,x2)==stego_image(A1,A2))
                        diff=0;
                    else
                        diff=stego_image(A1,A2)-stego_image(x1,x2);
                    end
                    
                    

                    if(diff<8)
                        ti=3;
                        L=0;
                    elseif(diff>7 && diff<16)
                        ti=3;
                        L=8;
                    elseif(diff>15 && diff<32)
                        ti=3;
                        L=16;
                    elseif(diff>31 && diff<64)
                        ti=3;
                        L=32;
                    elseif(diff>63 && diff<128)
                        ti=4;
                        L=64;
                    else
                        ti=4;
                        L=128;
                    end
                    if(length(final_message)>=1 && length(final_message)<ti)
                        final_message(length(final_message)+1:ti)=[0];
                    end
                    if(length(final_message)==0)
                        break
                    end

                    X_V=bi2de(final_message(ti:-1:1));

                    final_message(1:ti)=[];
                    DD=L+X_V;
                    
                    
                    
                    
                    pii=stego_image(A1,A2)-DD;
                    piii=stego_image(A1,A2)+DD;
                   
                    if(stego_image(x1,x2)>pii)
                        x=stego_image(x1,x2)-pii;
                    elseif(stego_image(x1,x2)==0)
                        x=0;
                    else
                        x=pii-stego_image(x1,x2);
                    end
                    if(stego_image(x1,x2)>piii)
                        y=stego_image(x1,x2)-piii;
                    elseif(stego_image(x1,x2)==piii)
                        y=0;
                    else
                        y=piii-stego_image(x1,x2);
                    end
                        
                        
                   
                    
                    if(x<y && pii>=0 && pii<=255)
                        stego_image(x1,x2)=pii;
                       
                 
                    else
                        stego_image(x1,x2)=piii;

                    end

                end
                if(length(final_message)==0)
                    break
                end
            end
            if(length(final_message)==0)
                break
            end
        end
            
        
        if(length(final_message)==0)
            break
        end
        
    end
    if(length(final_message)==0)
        break
    end
    
    i1=i1+3;
end

subplot 121;imshow(cover_image);title('Original Image');
subplot 122; imshow(stego_image);title('Stego image using PVD');
ps=psnr(stego_image,cover_image);
ss=ssim(stego_image,cover_image);
imwrite(stego_image,'stego_image.png'); 