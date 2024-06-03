import React, { ReactNode } from 'react';


interface MainButtonProps {
  children: ReactNode;
}

const MainButton: React.FC<MainButtonProps> = ({ children }) => {
  return (
    <button className='text-center text-night bg-dusty- py-2 font-normal text-3xl leading-[38px] uppercase bg-dusty-orange w-full'>
      {children}
    </button>
  )
}

export default MainButton