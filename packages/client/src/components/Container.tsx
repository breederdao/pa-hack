import React, { ReactNode } from 'react';

interface ContainerProps {
  children: ReactNode;
  title: string
}

const Container: React.FC<ContainerProps> = ({ children, title }) => {
  return (
    <div className='relative w-[528px] border-dusty-orange border-[5px] mx-auto text-dusty-orange bg-repeat font-courier
      before:absolute before:top-0 before:left-0 before:w-full before:h-full before:bg-gradient-to-b before:from-night before:from-10% before:to-cedar before:to-90% bg-[url(images/container-bg.png)] before:z-[-1]'>
      <div className='bg-[#010001] px-[40px] py-[15px] flex flex-row justify-between'>
        <div className='w-1/2 font-bold text-lg leading-[26px] flex items-center'>
          {title}
        </div>
        <div className='w-1/2 flex justify-end items-center'>
          <div className='w-[127.43px]'>
            <img src='./images/breederdao-logo.png' className='max-w-full w-full h-auto' />
          </div>
        </div>
      </div>
      <div className='px-10 pt-[26px] pb-[57px]'>
        {children}
      </div>
    </div>
  );
};

export default Container;