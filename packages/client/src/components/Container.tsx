import React, { ReactNode } from 'react';
import WebBrowserIcon from './icons/WebBrowserIcon';
import TwitterIcon from './icons/TwitterIcon';
import DiscordIcon from './icons/DiscordIcon';
import TiktokIcon from './icons/TiktokIcon';
import TelegramIcon from './icons/TelegramIcon';
import LinkedInIcon from './icons/LinkedInIcon';
import MediumIcon from './icons/MediumIcon';

interface ContainerProps {
  children: ReactNode;
  title: string
}

const Container: React.FC<ContainerProps> = ({ children, title }) => {
  return (
    <div className='w-screen h-screen flex justify-center items-center'>
      <div className='relative w-[528px] border-dusty-orange border-[5px] text-dusty-orange bg-repeat font-courier
        before:absolute before:top-0 before:left-0 before:w-full before:h-full before:bg-gradient-to-b before:from-night before:from-10% before:to-cedar before:to-90% bg-[url(images/container-bg.png)] before:z-[-1]'>
        <Header title={title} />
        <div className='px-10 pt-[26px] pb-[57px]'>
          {children}
        </div>
        <Footer />
      </div>
    </div>
  );
};

interface HeaderProps {
  title: string
}
const Header: React.FC<HeaderProps> = ({ title }) => {
  return (
    <div className='bg-[#010001] px-[40px] py-[15px] flex flex-row justify-between'>
      <div className='w-1/2 font-bold text-lg leading-[26px] flex items-center'>
        {title}
      </div>
      <div className='w-1/2 flex justify-end items-center'>
        <div className='w-[127.43px]'>
          <img src='./images/breederdao-logo.png' className='max-w-full w-full h-auto' alt='logo' />
        </div>
      </div>
    </div>
  )
}

const Footer = () => {
  return (
    <div className='bg-[#000000] pl-[30px] pr-4 py-[15px] flex flex-row justify-between'>
      <div className='w-1/2 font-bold text-xs leading-[14px] flex items-center text-rust'>
        Copyright
      </div>
      <div className='w-1/2 flex justify-end items-center [&>*]:mr-[16.67px] [&>:last-child]:mr-0'>
        <a href="#">
          <WebBrowserIcon />
        </a>
        <a href="#">
          <TwitterIcon />
        </a>
        <a href="#">
          <DiscordIcon />
        </a>
        <a href="#">
          <TiktokIcon />
        </a>
        <a href="#">
          <TelegramIcon />
        </a>
        <a href="#">
          <LinkedInIcon />
        </a>
        <a href="#">
          <MediumIcon />
        </a>
      </div>
    </div>
  )
}

export default Container;